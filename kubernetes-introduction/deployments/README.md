# Deployments

A deployment is a supervisor for pods, giving you fine-grained control over how and when a new pod version is rolled out as well as rolled back to a previous state.  
Let's create a deployment called sise-deploy that produces two replicas of a pod as well as a replica set:

```bash
kubectl apply -f sise-deployment-ver1.yaml
```

You can have a look at the deployment, as well as the the replica set and the pods the deployment looks using the get subcommand (multiple resource types may be specified in a single call):

```bash
kubectl get pod,replicaset,deployment
```

The result is separated by resource type and reflects all of the resources created by the deployment:

```console
NAME                               READY   STATUS    RESTARTS   AGE
pod/sise-deploy-747848cd97-d2hkf   1/1     Running   0          73s
pod/sise-deploy-747848cd97-klr7z   1/1     Running   0          73s

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/sise-deploy-747848cd97   2         2         2       74s

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/sise-deploy   2/2     2            2           74s
```

Note the naming of the pods and replica set, derived from the deployment name.

 
At this point in time the "sise" containers running in the pods are configured to return the version 0.9. Let's verify this from within the cluster using curl:

```bash
kubectl exec sise-deploy-747848cd97-d2hkf -t -- curl -s 127.0.0.1:9876/info
```

The output reflects the current version of the deployed application:

```console
{"host": "127.0.0.1:9876", "version": "0.9", "from": "127.0.0.1"}
```

Let's now see what happens if we change that version to 1.0 in an updated deployment:

```bash
kubectl apply -f sise-deployment-ver2.yaml
```

Note that you could have used kubectl edit deploy/sise-deploy instead to achieve the same by manually editing the deployment.  
Running the kubectl get pods command shows the rollout of two new pods with the updated version 1.0 as well as the two old pods with version 0.9 being terminated:

```console
NAME                           READY   STATUS        RESTARTS   AGE
sise-deploy-67fd84bd5c-g2kkw   1/1     Running       0          35s
sise-deploy-67fd84bd5c-s6bkv   1/1     Running       0          32s
sise-deploy-747848cd97-d2hkf   1/1     Terminating   0          6m47s
sise-deploy-747848cd97-klr7z   0/1     Terminating   0          6m47s
```

Additionally, a new replica set is created as well:
```console
NAME                     DESIRED   CURRENT   READY   AGE
sise-deploy-67fd84bd5c   2         2         2       51s
sise-deploy-747848cd97   0         0         0       7m3s
```

Note that during the deployment you can check the progress using kubectl rollout status deploy/sise-deploy.

To verify that if the new 1.0 version is really available, we execute from within the cluster (again using kubectl get pods get the name of one of the pods):

```bash
kubectl exec sise-deploy-67fd84bd5c-g2kkw -t -- curl -s 127.0.0.1:9876/info
```

The resulting output reflects the new version of the container image:

```console
{"host": "127.0.0.1:9876", "version": "1.0", "from": "127.0.0.1"}
```
A history of all deployments is available via the rollout history subcommand:

```bash
kubectl rollout history deploy/sise-deploy
```

If there are problems in the deployment Kubernetes will automatically roll back to the previous version, however you can also explicitly roll back to a specific revision, as in our case to revision 1 (the original pod version):

```bash
kubectl rollout undo deploy/sise-deploy --to-revision=1
```

At this point in time we're back at where we started, with two new pods again serving version 0.9, which can be verified with the curl command from above:

```console
{"host": "127.0.0.1:9876", "version": "0.9", "from": "127.0.0.1"}
```

Finally, to clean up, we remove the deployment. Kubernetes will delete any child resources (in this case, the replica sets and pods):

```bash
kubectl delete deploy sise-deploy
```