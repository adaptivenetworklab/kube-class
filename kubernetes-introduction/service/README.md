# Access Kubernetes Pod

## Port-forward

Digunakan sementara hanya untuk pengujian akses cepat aplikasi tanpa service. <br>
Berikut contoh command nya:
```
kubectl port-forward <resource-type/resource-name> [local_port]:<pod_port>
kubectl port-forward pods/my-pod 8080:80
kubectl port-forward deployment/my-deployment 8080:80
```

Lakukan Demo ini:
```bash
kubectl create -f nginx.yaml
kubectl get pods -o wide
kubectl port-forward pod/nginx 8080:80
curl 127.0.0.1:8080 # atau di browser dengan localhost:8080
kubectl port-forward pod/nginx :80 # port random
```

## Kubernetes Service

### NodePort
```bash
kubectl create -f nginx-lab-1.yml
kubectl expose deployment nginx-lab-1 --type=NodePort --port=80
kubectl get service
kubectl describe svc nginx-lab-1
# Akses di dalam cluster
kubectl exec nginx-lab-1-58f9bf94f7-jk85s -- curl -s http://10.108.252.53
# Akses di luar cluster
curl http://localhost:<Nodeport>
```

### LoadBalancer (Lab)
```bash
kubectl create -f nginx-deploy.yml
kubectl create -f lb-svc.yml
kubectl get service
# Akses di luar cluster
http://<external-ip>
```