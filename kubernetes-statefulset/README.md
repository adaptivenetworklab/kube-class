# Kubernetes Statefulset


## Steps

1. Check the storageclass for host path provisioner

```
kubectl get storageclass
```

2. Deploy our statefulset

```
kubectl apply -f statefulset.yaml
```

3. Enable Redis Cluster

```
kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379'
kubectl exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 --cluster create 10.244.1.6:6379 10.244.3.6:6379 10.244.2.8:6379"
kubectl exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 cluster info"
```

5. Deploy sample application
```
kubectl apply -f example-app.yaml
```

6. Akses Aplikasi di localhost:30002



### Referensi
https://rancher.com/blog/2019/deploying-redis-cluster 
https://youtu.be/zj6r_EEhv6s
