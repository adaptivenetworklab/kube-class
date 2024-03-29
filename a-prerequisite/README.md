# Local Installation Setup

## WSL 2 - Ubuntu 20.04

Berikut cara melakukan instalasi [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install).

## Docker Desktop

Berikut cara melakukan instalasi windows [Docker Desktop](https://youtu.be/Y_XPQ-7hjnY).

**Linux**:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```
Aktivasi Docker di WSL:
```
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

## KUBECTL
Kubectl adalah Kubernetes Command Line Interface (CLI) sehingga user dapat mengakses dan mengelola cluster melalui terminal. Berikut cara instalasinya:

**Windows**:
Berikut cara melakukan instalasi [Kubectl di Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).

**Linux**:
Download binary stable release versi terbaru dari kubectl.
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
```
## KUBERNETES KIND:
Kind adalah cluster Kubernetes yang menggunakan container sebagai instance cluster. Bersifat sangat ringan dan digunakan sebagai cluster sekali pakai dalam development process. Berikut cara instalasinya:

**Linux**:
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

**Windows**:
```
curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.17.0/kind-windows-amd64
Move-Item .\kind-windows-amd64.exe c:\Users\Users\kind.exe
```

```
cd ./a-prerequisite
kind create cluster --name adaptive-training --image kindest/node:v1.20.2 --config kind.yaml
```
