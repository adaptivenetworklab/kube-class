# Services

A service is an abstraction for pods, providing a stable, so called virtual IP (VIP) address. While pods may come and go and with it their IP addresses, a service allows clients to reliably connect to the containers running in the pod using the VIP. The "virtual" in VIP means it is not an actual IP address connected to a network interface, but its purpose is purely to forward traffic to one or more pods. Keeping the mapping between the VIP and the pods up-to-date is the job of kube-proxy, a process that runs on every node, which queries the API server to learn about new services in the cluster.

Let's create a new pod supervised by a replication controller and a service along with it:

```bash
kubectl apply -f rc.yaml
kubectl apply -f svc.yaml
```

Verify the pod is running:

```bash
kubectl get pods -l app=sise
```

A new pod name should be generated each time this example is run. Make sure to include your own pod name when running the following examples:

```bash
kubectl describe pod rcsise-nlfzs
```

The output should appear similar to the following (which has been truncated for readability):

```yaml
Name:         rcsise-nlfzs
Namespace:    default
Priority:     0
Node:         minikube/192.168.39.51
Start Time:   Thu, 03 Jun 2021 16:52:41 -0400
Labels:       app=sise
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:           172.17.0.3
Controlled By:  ReplicationController/rcsise
Containers:
  sise:
    Container ID:   docker://907686f441b6f30d8723c1a66ce9348955cded4934573d9a6703173f38a2d705
    Image:          quay.io/openshiftlabs/simpleservice:0.5.0
```

You can, from within the cluster, access the pod directly via its assigned IP 172.17.0.3:

```bash
kubectl exec rcsise-nlfzs -t -- curl -s 172.17.0.3:9876/info
```

This is however, as mentioned above, not advisable since the IPs assigned to pods may change as pods are migrated or rescheduled. The service created at the start of this lesson, simpleservice, is used to abstract the access to the pod away from a specific IP:

```bash
kubectl get service
```

The service resource type uses labels to identify which pods it will forward traffic to. In our case, pods labeled with app=sise will receive traffic.
 
From within the cluster, we can now access any affiliated pods using the IP address of the simpleservice service endpoint on port 80. KubeDNS even provides basic name resolution for Kubernetes services (within the same Kubernetes namespace). This allows us to connect to pods using the associated service name - no need to including IP addresses or port numbers.

```bash
kubectl exec rcsise-6nq3k -t -- curl -s simpleservice/info
```

Let’s now add a second pod by scaling up the RC supervising it:

```bash
kubectl scale --replicas=2 rc/rcsise
```

Wait for both pods to report they are in the "Running" state:

```bash
kubectl get pods -l app=sise
```

This causes the traffic to the service being equally split between our two pods.
 
You can remove all of the resources created by running:

```bash
kubectl delete svc simpleservice
kubectl delete rc rcsise
```