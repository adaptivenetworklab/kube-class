# Pods

A pod is a collection of containers sharing a network, acting as the basic unit of deployment in Kubernetes. All containers in a pod are scheduled on the same node.

## Creating it From Terminal

To launch a pod using the container imagequay.io/openshiftlabs/simpleservice:0.5.0 and exposing a HTTP API on port 9876, execute:

```bash
kubectl run sise --image=quay.io/openshiftlabs/simpleservice:0.5.0 --port=9876
```

Check to see if the pod is running:

```bash
kubectl get pods
```

Resulting in output similar to the following:

```console
NAME    READY   STATUS      RESTARTS    AGE
sise    1/1     Running         0       1m
```

If the above output returns a longer pod name, make sure to use it in the following examples (in place of sise).

This container image happens to include a copy of curl, which provides an additional way to verify that the primary webservice process is responding (over the local net at least):

```bash
kubectl exec sise -t -- curl -s localhost:9876/info
```

This call should produce the output:

```console
{"host": "localhost:9876", "version": "0.5.0", "from": "127.0.0.1"}
```

From within the cluster (e.g. via kubectl exec) this pod will also be directly accessible via it's associated pod IP 172.17.0.3:

```bash
kubectl describe pod sise | grep IP:
```

The kubernetes proxy API provides an additional opportunity to make external connections to pods within the cluster using `curl`:

```bash
export K8S_API="https://$(kubectl config get-clusters | tail -n 1)"
export API_TOKEN="$(kubectl config view -o jsonpath={.users[-1].user.token})"
export NAMESPACE="default"
export PODNAME="sise"
curl -s -k -H"Authorization: Bearer $API_TOKEN" $K8S_API/api/v1/namespaces/$NAMESPACE/pods/$PODNAME/proxy/info
```

Cleanup:

```bash
kubectl delete pod,deployment sise
```

## Creating from a Manifest

You can also create a pod from a manifest file. In this case the pod is running the already known simpleservice image from above along with a generic CentOS container:

```bash
kubectl apply -f pod.yaml
```

You can verify the created pod using the same command as above:

```bash
kubectl get pods
```

The output reflects that there is a single pod, however it has two containers in it:

```console
NAME                        READY   STATUS    RESTARTS   AGE
twocontainers               2/2     Running   0          36s
```

Containers that share a pod are able to communicate using local networking.

This example demonstrates how to exec into a sidecar shell container to access and inspect the sise container via localhost:

```bash
kubectl exec twocontainers -t -- curl -s localhost:9876/info
```

Define the resources attribute to influence how much CPU and/or RAM a container in a pod can use (this example uses 64MB of RAM and 0.5 CPUs):

```bash
kubectl create -f constraint-pod.yaml
```

The `describe` subcommand displays more information about a specific pod than `get` does.

```bash
kubectl describe pod constraintpod
```

There is quite a bit of information provided, with the resource limits displayed in the following snippets:
```yaml
...
Containers:
sise:
...
Limits:
cpu: 500m
memory: 64Mi
Requests:
cpu: 500m
memory: 64Mi
...
```

Learn more about resource constraints in Kubernetes via the docs here and here.
To clean up and remove all the remaining pods, run:

```bash
kubectl delete pod twocontainers
kubectl delete pod constraintpod
```

To sum up, launching one or more containers (together) in Kubernetes is simple, however doing it directly as shown above comes with a serious limitation: you have to manually take care of keeping them running in case of a failure. A better way to supervise pods is to use deployments, giving you much more control over the life cycle, including rolling out a new version.