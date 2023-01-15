# Role Based Access Control (RBAC)

# Introduction to Kubernetes: RBAC

## Create Kubernetes cluster


```
kind create cluster --name rbac --image kindest/node:v1.20.2
```

## Kubernetes CA Certificate

Kubernetes does not have a concept of users, instead it relies on certificates and would only 
trust certificates signed by its own CA. </br>

To get the CA certificates for our cluster, easiest way is to access the master node. </br>
Because we run on `kind`, our master node is a docker container. </br>
The CA certificates exists in the `/etc/kubernetes/pki` folder by default. </br>
If you are using `minikube` you may find it under `~/.minikube/.`

Access the master node:

```
docker exec -it rbac-control-plane bash

ls -l /etc/kubernetes/pki
total 60
-rw-r--r-- 1 root root 1135 Sep 10 01:38 apiserver-etcd-client.crt
-rw------- 1 root root 1675 Sep 10 01:38 apiserver-etcd-client.key
-rw-r--r-- 1 root root 1143 Sep 10 01:38 apiserver-kubelet-client.crt
-rw------- 1 root root 1679 Sep 10 01:38 apiserver-kubelet-client.key
-rw-r--r-- 1 root root 1306 Sep 10 01:38 apiserver.crt
-rw------- 1 root root 1675 Sep 10 01:38 apiserver.key
-rw-r--r-- 1 root root 1066 Sep 10 01:38 ca.crt
-rw------- 1 root root 1675 Sep 10 01:38 ca.key
drwxr-xr-x 2 root root 4096 Sep 10 01:38 etcd
-rw-r--r-- 1 root root 1078 Sep 10 01:38 front-proxy-ca.crt
-rw------- 1 root root 1679 Sep 10 01:38 front-proxy-ca.key
-rw-r--r-- 1 root root 1103 Sep 10 01:38 front-proxy-client.crt
-rw------- 1 root root 1675 Sep 10 01:38 front-proxy-client.key
-rw------- 1 root root 1679 Sep 10 01:38 sa.key
-rw------- 1 root root  451 Sep 10 01:38 sa.pub

exit the container
```

Copy the certs out of our master node:

```
cd kubernetes/rbac
docker cp rbac-control-plane:/etc/kubernetes/pki/ca.crt ca.crt
docker cp rbac-control-plane:/etc/kubernetes/pki/ca.key ca.key
```

# Kubernetes Users

As mentioned before, Kubernetes has no concept of users, it trusts certificates that is signed by its CA. <br/>
This allows a lot of flexibility as Kubernetes lets you bring your own auth mechanisms, such as [OpenID Connect](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens) or OAuth. </br>

 <p> This allows managed Kubernetes offerings to use their cloud logins to authenticate. </p>

 So on Azure, I can use my Microsoft account, GKE my Google account and AWS EKS my Amazon account. </br>

 You will need to consult your cloud provider to setup authentication. </br>
 Example [Azure AKS](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli)

## User Certificates

First thing we need to do is create a certificate signed by our Kubernetes CA. </br>
We have the CA, let's make a certificate. </br>

Easy way to create a cert is use `openssl` and the easiest way to get `openssl` is to simply run a container:

```
docker run -it -v ${PWD}:/work -w /work -v ${HOME}:/root/ --net host alpine sh

docker exec -it [image id] sh 

apk add openssl
```

Let's create a certificate for Bob Smith:


```
#start with a private key
openssl genrsa -out bob.key 2048

```

Now we have a key, we need a certificate signing request (CSR). </br>
We also need to specify the groups that Bob belongs to. </br>
Let's pretend Bob is part of the `Shopping` team and will be developing 
applications for the `Shopping` 

```
openssl req -new -key bob.key -out bob.csr -subj "/CN=Bob Smith/O=Shopping"
```

Use the CA to generate our certificate by signing our CSR. </br>
We may set an expiry on our certificate as well

```

```

## Building a kube config

Let's install `kubectl` in our container to make things easier:

```
apk add curl nano
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
```

We'll be trying to avoid messing with our current kubernetes config. </br>
So lets tell `kubectl` to look at a new config that does not yet exists 

```
mkdir ~/.kube
touch ~/.kube/user1-config
export KUBECONFIG=~/.kube/user1-config
```

Create a cluster entry which points to the cluster and contains the details of the CA certificate:

```
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 \
--certificate-authority=ca.crt \
--embed-certs=true

#see changes 
nano ~/.kube/user1-config
```

# How to Generate Kubeconfig File?

A kubeconfig needs the following important details.

    1. Cluster endpoint (IP or DNS name of the cluster)
    2. Cluster CA Certificate
    3. Cluster name
    4. Service account user name
    5. Service account token

`Note: To generate a Kubeconfig file, you need to have admin permissions in the cluster to create service accounts and roles.`

For this demo, I am creating a service account with `clusterRole` that has limited access to the cluster-wide resources. You can also create a normal role and `Rolebinding` that limits the user access to a specific namespace.

## Step 1: Create a Service Account

The service account name will be the user name in the Kubeconfig. Here I am creating the service account in the kube-system as I am creating a clusterRole. If you want to create a config to give namespace level limited access, create the service account in the required namespace.

```console
kubectl -n kube-system create serviceaccount devops-cluster-admin
```

## Step 2: Create a ClusterRole

Let’s create a clusterRole with limited privileges to cluster objects. You can add the required object access as per your requirements. Refer to the service account with clusterRole access blog for more information.

If you want to create a namespace scoped role, refer to creating service account with role.

Execute the following command to create the clusterRole.
```console
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: devops-cluster-admin
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
EOF
```

## Step 3: Create ClusterRoleBinding

The following YAML is a ClusterRoleBinding that binds the devops-cluster-admin service account with the devops-cluster-admin clusterRole.

```console
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: devops-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: devops-cluster-admin
subjects:
- kind: ServiceAccount
  name: devops-cluster-admin
  namespace: kube-system
EOF
```

## Step 4: Get all Cluster Details & Secrets

We will retrieve all the required kubeconfig details and save them in variables. Then, finally, we will substitute it directly to the Kubeconfig YAML.

```console
export SA_TOKEN_NAME=$(kubectl -n kube-system get serviceaccount devops-cluster-admin -o=jsonpath='{.secrets[0].name}')

export SA_SECRET_TOKEN=$(kubectl -n kube-system get secret/${SA_TOKEN_NAME} -o=go-template='{{.data.token}}' | base64 --decode)

export CLUSTER_NAME=$(kubectl config current-context)

export CURRENT_CLUSTER=$(kubectl config view --raw -o=go-template='{{range .contexts}}{{if eq .name "'''${CLUSTER_NAME}'''"}}{{ index .context "cluster" }}{{end}}{{end}}')

export CLUSTER_CA_CERT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}"{{with index .cluster "certificate-authority-data" }}{{.}}{{end}}"{{ end }}{{ end }}')

export CLUSTER_ENDPOINT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}{{ .cluster.server }}{{end}}{{ end }}')
```

## Step 5: Generate the Kubeconfig With the variables.

If you execute the following YAML, all the variables get substituted and a config named devops-cluster-admin-config gets generated.

```console
cat << EOF > devops-cluster-admin-config
apiVersion: v1
kind: Config
current-context: ${CLUSTER_NAME}
contexts:
- name: ${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    user: devops-cluster-admin
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CLUSTER_CA_CERT}
    server: ${CLUSTER_ENDPOINT}
users:
- name: devops-cluster-admin
  user:
    token: ${SA_SECRET_TOKEN}
EOF
```

## Step 5: validate the generated Kubeconfig

To validate the Kubeconfig, execute it with the kubectl command to see if the cluster is getting authenticated.
```console
kubectl get nodes --kubeconfig=devops-cluster-admin-config 
```


```

kubectl config set-credentials user1 --client-certificate=user1.crt  --client-key=user1.key --embed-certs=true

kubectl config set-context training --cluster=training-cluster --namespace=training --user=user1 

kubectl config use-context training

kubectl get pods
Error from server (Forbidden): pods is forbidden: User "Bob Smith" cannot list resource "pods" in API group "" in the namespace "shopping"
```

## Give Bob Smith Access

```
cd kubernetes/rbac
kubectl create ns shopping

kubectl -n shopping apply -f .\role.yaml
kubectl -n shopping apply -f .\rolebinding.yaml
```

## Test Access as Bob

kubectl get pods
No resources found in shopping namespace.

# Kubernetes Service Accounts

So we've covered users, but what about applications or services running in our cluster ? </br>
Most business apps will not need to connect to the kubernetes API unless you are building something that integrates with your cluster, like a CI/CD tool, an autoscaler or a custom webhook. </br>

Generally applications will use a service account to connect. </br>
You can read more about [Kubernetes Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/).

Let's deploy a service account 

```
kubectl -n shopping apply -f serviceaccount.yaml

```
Now we can deploy a pod that uses the service account 
```
kubectl -n shopping apply -f pod.yaml
```
Now we can test the access from within that pod by trying to list pods:

```
kubectl -n shopping exec -it shopping-api -- bash

# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

# List pods through the API
curl --cacert ${CACERT} --header "Authorization: Bearer $TOKEN" -s ${APISERVER}/api/v1/namespaces/shopping/pods/ 

# we should see an error not having access
```

Now we can allow this pod to list pods in the shopping namespace
```
kubectl -n shopping apply -f serviceaccount-role.yaml
kubectl -n shopping apply -f serviceaccount-rolebinding.yaml
```

If we try run `curl` command again we can see now we are able to get a json 
response with pod information


### Referensi 
https://youtu.be/jvhKOAyD8S8

for n in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  echo -n "$n: "
  kubectl auth can-i get pods -n "$n" --as=user11
done
