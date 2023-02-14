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
