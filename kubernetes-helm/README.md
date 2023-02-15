# Kubernetes Helm

### Ekslplorasi Fitur
1. Template Gerenation Capability
2. Simplify deploy 1 application
3. Automatically rollout new pod
4. Control Flow & Pipeline

### Steps

Firstly, I like to do most of my work in containers so everything is reproducible  <br/>
and my machine remains clean.

## Get a container to work in
<br/>
Run a small `alpine linux` container where we can install and play with `helm`: <br/>

```bash
docker run -it --rm -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host alpine sh

# install curl & kubectl
apk add --no-cache curl nano 
apk add openssl
apk add bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
export KUBE_EDITOR="nano"
```

```bash
## Install Helm CLI
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Create our first Chart

For reference in the rest of the guide, I have left my full templates in: 
```
cd kubernetes-helm/

helm create training-app
```

## Cleanup the template 

We can delete unwanted files:

* delete everything under /templates, keeping only `_helpers.tpl`
* delete `tests` folder under `templates`

## Masukan aplikasi ke dalam template

Pindahkan yang ada di app ke dalam template folder

## Test the rendering of our template

```
helm template training-app training-app
```

## Install our app using our Chart

```
helm install training-app training-app

# list our releases

helm list

# see our deployed components

kubectl get all
kubectl get cm
kubectl get secret
```
 
## Value injections for our Chart

For CI systems, we may want to inject an image tag as a build number <br/>

Basic parameter injection: <br/>

```
# values.yaml

deployment:
  image: "aimvector/python"
  tag: "1.0.4"

# deployment.yaml

image: {{ .Values.deployment.image }}:{{ .Values.deployment.tag }}

# upgrade our release

helm upgrade training-app training-app --values ./training-app/values.yaml

# see revision increased

helm list
```

## Make our Chart more generic

Let's make our chart generic so it can be reused: <br/>
For the following objects, replace `example-deploy` and `example-app` to inject: `"{{ .Values.name }}"`

* deployment.yaml
* services.yaml
* secret.yaml
* configmap.yaml

Now that our application is generic <br/>
We can deploy another copy of it.<br/>
<br/>

Rename `values.yaml` to `example-app.values.yaml`
Create our second app values file `example-app-02.values.yaml`

```
helm upgrade training-app training-app --values ./training-app/values.yaml
helm install training-app-2 training-app --values ./training-app/values2.yaml
helm list
```


## If\Else and Default values

You can also set default values in case they are not supplied by the `values.yaml` file. <br/>
This may help you keep the `values.yaml` file small <br/>

```
{{- if .Values.deployment.resources }}
  resources:
    {{- if .Values.deployment.resources.requests }}
    requests:
      memory: {{ .Values.deployment.resources.requests.memory | default "50Mi" | quote }}
      cpu: {{ .Values.deployment.resources.requests.cpu | default "10m" | quote }}
    {{- else}}
    requests:
      memory: "50Mi"
      cpu: "10m"
    {{- end}}
    {{- if .Values.deployment.resources.limits }}
    limits:
      memory: {{ .Values.deployment.resources.limits.memory | default "1024Mi" | quote }}
      cpu: {{ .Values.deployment.resources.limits.cpu | default "1" | quote }}
    {{- else}}  
    limits:
      memory: "1024Mi"
      cpu: "1"
    {{- end }}
  {{- else }}
  resources:
    requests:
      memory: "50Mi"
      cpu: "10m"
    limits:
      memory: "1024Mi"
      cpu: "1"
  {{- end}} 


# rollout the change

helm upgrade example-app example-app --values ./example-app/example-app-01.values.yaml
```

### Referensi

https://youtu.be/5_J7RWLLVeQ
