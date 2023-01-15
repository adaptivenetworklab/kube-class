# Kubernetes Example Deployment

Since we have looked at the basics let start with an example deployment. We will do the following in this section.

    1. Create a namespace
    2. Create a Nginx Deployment
    3. Create a Nginx Service
    4. Expose and access the Nginx Service

` Note: Few of the operations we perform in this example can be performed with just kubectl and without a YAML Declaration. However, we are using the YAML specifications for all operations to understand it better. `

## Exercise Folder 

To begin the exercise, create a folder names deployment-demo and cd into that folder. Create all the exercise files in this folder.

```console
mkdir deployment-demo && cd deployment-demo
```

## Create a Namespace

Let’s create a YAML named namespace.yaml file for creating the namespace.

```console
apiVersion: v1
kind: Namespace
metadata:
  name: deployment-demo
  labels:
    apps: web-based
  annotations:
    type: demo
```

Use kubectl command to create the namespace.

```console
kubectl create -f namespace.yaml
```

Equivalent kubectl command

```console
kubectl create namespace deployment-demo
```

## Assign Resource Quota To Namespace

Now let’s assign some resource quota limits to our newly created namespace. This will make sure the pods deployed in this namespace will not consume more system resources than mentioned in the resource quota.

Create a file named resourceQuota.yaml. Here is the resource quota YAML contents.

```console
apiVersion: v1
kind: ResourceQuota
metadata:
  name: mem-cpu-quota
  namespace: deployment-demo
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
```

Create the resource quota using the YAML.

```console
kubectl create -f resourceQuota.yaml
```
Now, let’s describe the namespace to check if the resource quota has been applied to the deployment-demo namespace.

```console
kubectl describe ns deployment-demo
```

The output should look like the following.
```console
Name:         deployment-demo
Labels:       apps=web-based
Annotations:  type=demo
Status:       Active

Resource Quotas
 Name:            mem-cpu-quota
 Resource         Used  Hard
 --------         ---   ---
 limits.cpu       0     2
 limits.memory    0     2Gi
 requests.cpu     0     1
 requests.memory  0     1Gi
```
## Create a Deployment

We will use the public Nginx image for this deployment.

Create a file named deployment.yaml and copy the following YAML to the file.

`Note: This deployment YAML has minimal required information we discussed above. You can have more specification in the deployment YAML based on the requirement.`

```console
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
  namespace: deployment-demo
  annotations:
    monitoring: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: "2Gi"
            cpu: "1000m"
          requests: 
            memory: "1Gi"
            cpu: "500m"
```

Under containers, we have defined its resource limits, requests and container port (one exposed in Dockerfile).

Create the deployment using kubectl

```console
kubectl create -f deployment.yaml
```

Check the deployment

```console
kubectl get deployments -n deployment-demo
```

Even though we have added minimal information, after deployment, Kubernetes will add more information to the deployment such as resourceVersion, uid, status etc.

You can check it by describing the deployment in YAML format using the kubectl command.

```console
kubectl get deployment nginx -n deployment-demo  --output yaml
```

## Create a Service and Expose The Deployment

Now that we have a running deployment, we will create a Kubernetes service of type NodePort ( 30500) pointing to the nginx deployment. Using NodePort you will be able to access the Nginx service on all the kubernetes node on port 30500.

Create a file named service.yaml and copy the following contents.

```console
apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginx
  name: nginx
  namespace: deployment-demo
spec:
  ports:
  - nodePort: 30500
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: NodePort
```

Service is the best example for explaining labels and selectors. In this service, we have a selector with “app” = “nginx” label. Using this, the service will be able to match the pods in our nginx deployment as the deployment and the pods have the same label. So automatically all the requests coming to the nginx service will be sent to the nginx deployment.

Let’s create the service using kubectl command.

```console
kubectl create -f service.yaml
```

You can view the service created using kubectl command.

```console
kubectl get services  -n deployment-demo
```
Now, you will be able to access the nginx service on any one of the kubernetes node IP on port 30500

For example,

```console
http://35.134.110.153:30500/
```