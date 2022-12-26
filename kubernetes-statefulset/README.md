# Kubernetes Statefulset


## Steps

1. Membuat Namespase Example

```
kubectl create ns example
```

2. Check the storageclass for host path provisioner

```
kubectl get storageclass
```

3. Deploy our statefulset

```
kubectl -n example apply -f .\kubernetes\statefulsets\statefulset.yaml
```

4. Enable Redis Cluster

```
$IPs = $(kubectl -n example get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
kubectl -n example exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 --cluster create ${IPs}"
kubectl -n example exec -it redis-cluster-0  -- /bin/sh -c "redis-cli -h 127.0.0.1 -p 6379 cluster info"
```

5. Deploy sample application
```
kubectl -n example apply -f .\kubernetes\statefulsets\example-app.yaml
```



### Referensi
https://rancher.com/blog/2019/deploying-redis-cluster 
https://youtu.be/zj6r_EEhv6s
