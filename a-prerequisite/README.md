# Local Installation Setup

## WSL 2 - Ubuntu 20.04

Berikut cara melakukan instalasi [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install).

## Docker Desktop

Berikut cara melakukan instalasi [Docker Desktop](https://youtu.be/Y_XPQ-7hjnY).


## KUBECTL
Kubectl adalah Kubernetes Command Line Interface (CLI) sehingga user dapat mengakses dan mengelola cluster melalui terminal. Berikut cara instalasinya:

**Windows**:
Berikut cara melakukan instalasi [Kubectl di Windows](https://youtu.be/G9MmLUsBd3g).

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
