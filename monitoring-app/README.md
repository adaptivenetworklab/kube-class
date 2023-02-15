# Introduction to Service Monitors

## Deploy kube-prometheus

Installation: 

```
kubectl create ns monitoring
```

```
kubectl create -f ./monitoring-app/manifests/setup/
kubectl create -f ./monitoring-app/manifests/
```

Deletion: 

```
kubectl delete -f ./monitoring-app/manifests/setup/
kubectl delete -f ./monitoring-app/manifests/
```

Check the install:

```
kubectl -n monitoring get pods
```

After a few minutes, everything should be up and running:

```
kubectl -n monitoring get pods
NAME                                   READY   STATUS    RESTARTS   AGE
alertmanager-main-0                    2/2     Running   0          3m10s
alertmanager-main-1                    2/2     Running   0          3m10s
alertmanager-main-2                    2/2     Running   0          3m10s
blackbox-exporter-6b79c4588b-t4czf     3/3     Running   0          4m7s
grafana-7fd69887fb-zm2d2               1/1     Running   0          4m7s
kube-state-metrics-55f67795cd-f7frb    3/3     Running   0          4m6s
node-exporter-xjdtn                    2/2     Running   0          4m6s
prometheus-adapter-85664b6b74-bvmnj    1/1     Running   0          4m6s
prometheus-adapter-85664b6b74-mcgbz    1/1     Running   0          4m6s
prometheus-k8s-0                       2/2     Running   0          3m9s
prometheus-k8s-1                       2/2     Running   0          3m9s
prometheus-operator-6dc9f66cb7-z98nj   2/2     Running   0          4m6s
```

## View dashboards

```
kubectl -n monitoring port-forward svc/grafana 3000
```

Then access Grafana on [localhost:3000](http://localhost:3000)

## Access Prometheus 

```
kubectl -n monitoring port-forward svc/prometheus-operated 9090
```

Then access Prometheus on [localhost:9090](http://localhost:9090).

## Create our own Prometheus 


```
kubectl apply -n monitoring -f ./monitoring-app/servicemonitors/prometheus.yaml

```

View our prometheus `prometheus-applications-0` instance:

```
kubectl -n monitoring get pods
```

Checkout our prometheus UI

```
kubectl -n monitoring port-forward prometheus-applications-0 9090
```

## Deploy a service monitor for example app

```
kubectl -n default apply -f ./monitoring-app/servicemonitors/servicemonitor.yaml
```

After applying the service monitor, if Prometheus is correctly selecting it, we should see the item appear under the [Service Discovery](http://localhost:9090/service-discovery) page in Prometheus. </br>
Double check with with `port-forward` before proceeding. </br>
If it does not appear, that means your Prometheus instance is not selecting the service monitor accordingly. Either a label mismatch on the namespace or the service monitor. </br>

## Deploy our example app

```
kubectl -n default apply -f ./monitoring-app/servicemonitors/example-app/
```

Now we should see a target in the Prometheus [Targets](http://localhost:9090/targets) page. </br>

## install Prometheus-operator

1. add repos

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```bash

2. install chart

```bash
helm install prometheus-training prometheus-community/kube-prometheus-stack
helm install metrics-training prometheus-community/kube-state-metrics
helm install exporte-training prometheus-community/prometheus-node-exporte
helm install grafana-training grafana/grafana
```

3. Uninstall chart 

```bash
helm uninstall prometheus-training prometheus-community/kube-prometheus-stack
helm uninstall metrics-training prometheus-community/kube-state-metrics
helm uninstall exporte-training prometheus-community/prometheus-node-exporte
helm uninstall grafana-training grafana/grafana
```

Link to chart
[https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack]