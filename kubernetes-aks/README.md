# Getting Started with AKS

Buat Cluster Menggunakan Azure Portal

## Azure CLI

```
# Run Azure CLI
docker run -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh mcr.microsoft.com/azure-cli:2.6.0
```

## Login to Azure
Connect sesuai dengan subsription di Portal Azure
```
az account set --subscription 7ca868c2-b2bd-468c-abba-c79c963bb881
az aks get-credentials --resource-group training-aks --name training
```

## Get kubectl

You have two options for installing `kubectl` <br/>

Option 1: Install using `az` CLI

```
az aks install-cli
```

Option 2: Download the binary using `curl` and place in usr bin

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
```

## Deploy MongoDB Application

1. Buat StorageClass terlebih dahulu
https://docs.docker.com.xy2401.com/ee/ucp/kubernetes/storage/use-azure-disk/ 
    ```bash
    cat <<EOF | kubectl create -f -
    kind: StorageClass
    apiVersion: storage.k8s.io/v1
    metadata:
    name: standard
    provisioner: kubernetes.io/azure-disk
    parameters:
    storageaccounttype: Standard_LRS
    kind: Managed
    EOF
    ```
2. List Storage Class yang ada di dalam azure
    ```console
    NAME                    PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    azurefile               file.csi.azure.com         Delete          Immediate              true                   24m
    azurefile-csi           file.csi.azure.com         Delete          Immediate              true                   24m
    azurefile-csi-premium   file.csi.azure.com         Delete          Immediate              true                   24m
    azurefile-premium       file.csi.azure.com         Delete          Immediate              true                   24m
    default (default)       disk.csi.azure.com         Delete          WaitForFirstConsumer   true                   24m
    managed                 disk.csi.azure.com         Delete          WaitForFirstConsumer   true                   24m
    managed-csi             disk.csi.azure.com         Delete          WaitForFirstConsumer   true                   24m
    managed-csi-premium     disk.csi.azure.com         Delete          WaitForFirstConsumer   true                   24m
    managed-premium         disk.csi.azure.com         Delete          WaitForFirstConsumer   true                   24m
    standard                kubernetes.io/azure-disk   Delete          Immediate              false                  20m

    ```
3. Install Helm

    ```bash
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```

4. Tambahkan Repository Bitnami

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    ```
    ```bash
    helm search repo bitnami
    ```
    ```bash
    helm search repo bitnami/mongo
    ```
5. Deploy Aplikasi MongoDB menggunakan helm
    Values berasal dari file `test-mongodb-values.yaml`
    ```bash
    helm install mongodb --values test-mongodb-values.yaml bitnami/mongodb
    ```
    Cek pods dengan 3 replica sesuai dengan konfigurasi helm values. `kubectl get all`

    Yang mana masing-masing pod memiliki physical disk dari azure. (Tunjukan SS)

6. Akses Aplikasi Menggunakan Loadbalacer Service
    ```bash
    curl 20.248.232.119:8081
    ```
    Atau akses melalui browser http://20.248.232.119:8081

    Atau dengan ingress (nama service)-c64ac81a.hcp.australiaeast.azmk8s.io

## Clean up 

```
az group delete -n $RESOURCEGROUP
az ad sp delete --id $SERVICE_PRINCIPAL
```
