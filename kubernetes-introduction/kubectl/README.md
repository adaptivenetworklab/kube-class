# Introduction to KUBECTL

## Working with Kubernetes resources

Now that we have cluster access, next we can read resources from the cluster
with the `kubectl get` command.

```
kubectl get nodes | pod | service| replicaset | deployment | namespaces
```

Menggunakan perintah Imperative kubectl dapat membantu dalam membuat object dengan cepat:

• Contoh membuat NGINX pod
```kubectl run nginx --image=nginx```  

• Generate POD Manifest YAML file dengan satu command
```kubectl run nginx --image=nginx --dry-run=client -o yaml```

• Membuat deployment
```kubectl create deployment --image=nginx nginx```

• Generate Deployment Manifest YAML file dengan satu command:

```kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml```

• Di dalam k8s version 1.19+, kita bisa melakukan spesifikasi konfigurasi –replicas untuk membuat deployment dengan misal 4 replicas.
```kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml```


## Namespaces 

### Create resources in a namespace

We can create a namespace with the `kubectl create` command:

```
kubectl create ns example-apps
```

Let's create a couple of resources:

```
kubectl -n example-apps create deployment webserver --image=nginx --port=80
kubectl -n example-apps get deploy
kubectl -n example-apps get pods

kubectl -n example-apps create service clusterip webserver --tcp 80:80
kubectl -n example-apps get service
kubectl -n example-apps port-forward svc/webserver 8888:80

# we can access http://localhost/
```

## Working with YAML

As you can see we can create resources with `kubectl` but this is only for basic testing purposes.
Kubernetes is a declarative platform, meaning we should provide it what to create instead
of running imperative line-by-line commands. </br>

We can also get the YAML of pre-existing objects in our cluster with the `-o yaml` flag on the `get` command </br>

Let's output all our YAML to a `yaml` folder:

```
kubectl -n example-apps get cm webserver-config -o yaml > .\kubernetes\kubectl\yaml\config.yaml
kubectl -n example-apps get secret webserver-secret -o yaml > .\kubernetes\kubectl\yaml\secret.yaml
kubectl -n example-apps get deploy webserver -o yaml > .\kubernetes\kubectl\yaml\deployment.yaml
kubectl -n example-apps get svc webserver -o yaml > .\kubernetes\kubectl\yaml\service.yaml   
```

## Create resources from YAML files

The most common and recommended way to create resources in Kubernetes is with the `kubectl apply` command. </br>
This command takes in declarative `YAML` files.

To show you how powerful it is, instead of creating things line-by-line, we can deploy all our infrastructure
with a single command. </br>

Let's deploy a Wordpress CMS site, with a back end MySQL database. </br>
This is a snippet taken from my `How to learn Kubernetes` video:

```
kubectl create ns wordpress-site
kubectl -n wordpress-site apply -f ./yaml/
```

We can checkout our site with the `port-forward` command:

```
kubectl -n wordpress-site get svc

NAME        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
mysql       ClusterIP   10.96.146.75   <none>        3306/TCP   17s
wordpress   ClusterIP   10.96.157.6    <none>        80/TCP     17s

kubectl -n wordpress-site port-forward svc/wordpress 80
```
