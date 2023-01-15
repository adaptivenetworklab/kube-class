#!/bin/bash
i=2
while true; do
  if [[ "$i" -gt 10 ]]; then
       exit 1
  fi
  echo i: $i
    # Create User Certificate
  openssl genrsa -out user$i.key 2048
  openssl req -new -key user$i.key -out user$i.csr -subj "/CN=User$i/O=Training"
  openssl x509 -req -in user$i.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out user$i.crt -days 365
  
    # Create Kube-Config
  touch ~/.kube/user$i-config
  export KUBECONFIG=~/.kube/user$i-config

    # Configure Kube-Config 

  kubectl config set-cluster training-cluster --server=https://k8s.adaptivenetworklab.org:6443 --certificate-authority=ca.crt --embed-certs=true

  kubectl config set-credentials user$i --client-certificate=user$i.crt  --client-key=user$i.key --embed-certs=true

  kubectl config set-context training --cluster=training-cluster --namespace=training --user=user$i

  kubectl config set-context user$i --cluster=training-cluster --namespace=user$i --user=user$i

  kubectl config use-context training
  ((i++))

done