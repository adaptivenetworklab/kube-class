## Cara Melihat Konfigurasi State Cluter dalam ETCD

1. Lihat lokasi cert, ca & key file dalam cluster
```bash
kubectl get pod -n kube-system -o yaml | grep -i etcd
```
Output:
```console
      - --etcd-cafile=/etc/ssl/etcd/ssl/ca.pem
      - --etcd-certfile=/etc/ssl/etcd/ssl/node-node1.pem
      - --etcd-keyfile=/etc/ssl/etcd/ssl/node-node1-key.pem
      - --etcd-servers=https://172.20.1.79:2379
      - --storage-backend=etcd3
      - mountPath: /etc/ssl/etcd/ssl
        name: etcd-certs-0
        path: /etc/ssl/etcd/ssl
      name: etcd-certs-0
```

2. Akses menggunakan lokasi endpoint cluster
```bash
sudo ETCDCTL_API=3 etcdctl --endpoints https://172.20.1.79:2379 --cert=/etc/ssl/etcd/ssl/node-node1.pem --key=/etc/ssl/etcd/ssl/node-node1-key.pem --cacert=/etc/ssl/etcd/ssl/ca.pem get /registry/ --prefix --keys-only
```
Output:
```console
/registry/apiregistration.k8s.io/apiservices/v1.
/registry/apiregistration.k8s.io/apiservices/v1.admissionregistration.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.apiextensions.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.apps
/registry/apiregistration.k8s.io/apiservices/v1.authentication.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.autoscaling
/registry/apiregistration.k8s.io/apiservices/v1.batch
...
```


3. Melihat dalam format JSON

```bash
sudo ETCDCTL_API=3 etcdctl --endpoints https://172.20.1.79:2379 --cert=/etc/ssl/etcd/ssl/node-node1.pem --key=/etc/ssl/etcd/ssl/node-node1-key.pem --cacert=/etc/ssl/etcd/ssl/ca.pem watch --prefix /registry/pods/default/ --write-out=json
```
Contoh output ketika membuat nginx pod/default

```JSON
{
  "Header": {
    "cluster_id": 11932888930204400000,
    "member_id": 5591604295743868000,
    "revision": 7502456,
    "raft_term": 16
  },
  "Events": [
    {
      "kv": {
        "key": "L3JlZ2lzdHJ5L3BvZHMvZGVmYXVsdC9uZ2lueHh4",
        "create_revision": 7502456,
        "mod_revision": 7502456,
        "version": 1,
        "value": "xxx"
      }
    }
  ],
  "CompactRevision": 0,
  "Canceled": false,
  "Created": false
}
```