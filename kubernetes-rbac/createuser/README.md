

```bash
openssl genrsa -out fauzan.key 2048
openssl genrsa -out darrel.key 2048
openssl genrsa -out ardi.key 2048
openssl genrsa -out humairah.key 2048
openssl genrsa -out eric.key 2048
openssl genrsa -out farel.key 2048
```
```bash
openssl req -new -key fauzan.key -out fauzan.csr -subj "/CN=Fauzan Fahlevi/O=training"
openssl req -new -key darrel.key -out darrel.csr -subj "/CN=Darrel Johan/O=training"
openssl req -new -key ardi.key -out ardi.csr -subj "/CN=Ardi Hermanto/O=training"
openssl req -new -key humairah.key -out humairah.csr -subj "/CN=Humairah Milleony/O=training"
openssl req -new -key eric.key -out eric.csr -subj "/CN=Johan Eric/O=training"
openssl req -new -key farel.key -out farel.csr -subj "/CN=Alfarelzi/O=training"
```

```bash
cat fauzan.csr | base64 | tr -d '\n'
cat darrel.csr | base64 | tr -d '\n'
cat ardi.csr | base64 | tr -d '\n'
cat humairah.csr | base64 | tr -d '\n'
cat eric.csr | base64 | tr -d '\n'
cat farel.csr | base64 | tr -d '\n'
```

Masukan CSR ke dalam Request Field dalam masing2 csr.yaml

```bash
kubectl apply -f csr/
kubectl get csr #Masih Pending
kubectl certificate approve fauzan
kubectl certificate approve darrel
kubectl certificate approve ardi
kubectl certificate approve humairah
kubectl certificate approve eric
kubectl certificate approve farel
kubectl get csr #Sudah Approved
```

```bash
kubectl get csr fauzan -oyaml
kubectl get csr darrel -oyaml
kubectl get csr ardi -oyaml
kubectl get csr humairah -oyaml
kubectl get csr eric -oyaml
kubectl get csr farel -oyaml
```

```bash
echo certificate | base64 -d > fauzan.crt
echo certificate | base64 -d > darrel.crt
echo certificate | base64 -d > ardi.crt
echo certificate | base64 -d > humairah.crt
echo certificate | base64 -d > eric.crt
echo certificate | base64 -d > farel.crt
```

Konfigurasi KUBECONFIG peruser

```bash
export KUBECONFIG=/mnt/c/Users/rafli/.kube/fauzan-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials fauzan --client-certificate=fauzan.crt  --client-key=fauzan.key --embed-certs=true
kubectl config set-context fauzan --cluster=training-cluster --namespace=fauzan --user=fauzan
kubectl config use-context fauzan
```
```bash
touch /mnt/c/Users/rafli/.kube/darrel-config
export KUBECONFIG=/mnt/c/Users/rafli/.kube/darrel-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials darrel --client-certificate=darrel.crt  --client-key=darrel.key --embed-certs=true
kubectl config set-context darrel --cluster=training-cluster --namespace=darrel --user=darrel
kubectl config use-context darrel
```
```bash
touch /mnt/c/Users/rafli/.kube/ardi-config
export KUBECONFIG=/mnt/c/Users/rafli/.kube/ardi-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials ardi --client-certificate=ardi.crt  --client-key=ardi.key --embed-certs=true
kubectl config set-context ardi --cluster=training-cluster --namespace=ardi --user=ardi
kubectl config use-context ardi
```
```bash
touch /mnt/c/Users/rafli/.kube/humairah-config
export KUBECONFIG=/mnt/c/Users/rafli/.kube/humairah-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials humairah --client-certificate=humairah.crt  --client-key=humairah.key --embed-certs=true
kubectl config set-context humairah --cluster=training-cluster --namespace=humairah --user=humairah
kubectl config use-context humairah
```
```bash
touch /mnt/c/Users/rafli/.kube/eric-config
export KUBECONFIG=/mnt/c/Users/rafli/.kube/eric-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials eric --client-certificate=eric.crt  --client-key=eric.key --embed-certs=true
kubectl config set-context eric --cluster=training-cluster --namespace=eric --user=eric
kubectl config use-context eric
```
```bash
touch /mnt/c/Users/rafli/.kube/farel-config
export KUBECONFIG=/mnt/c/Users/rafli/.kube/farel-config
kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials farel --client-certificate=farel.crt  --client-key=farel.key --embed-certs=true
kubectl config set-context farel --cluster=training-cluster --namespace=farel --user=farel
kubectl config use-context farel
```

Coba Testing KUBECONFIG File dengan melakukan merging dengan kubeconfig local




