# Port Forwarding

In the context of developing applications on Kubernetes, it is often useful to quickly access a service from your local environment without exposing it using, for example, a load balancer or an ingress resource. In these situations, you can use port forwarding.

Let's create an application consisting of a deployment and a service named simpleservice, serving on port 80:

```bash
kubectl apply -f app.yaml
```

Let's say we want to access the simpleservice service from the local environment on port 8080. Traffic can be forwarded to your local system using the port-forward subcommand:

```bash
kubectl port-forward service/simpleservice 8080:80
```

This command does not immediately complete; as long as it is running, the port forward will be in use. We can verify the service is accessible by accessing it over port 8080 (you'll need a separate terminal):

Now we can invoke the service locally like so (using a separate terminal session):

```bash
curl localhost:8080/info
```

The output should resemble the following:

```console
{"host": "localhost:8080", "version": "0.5.0", "from": "127.0.0.1"}
```

Remember that port forwarding is not meant for production traffic, but for development and experimentation.
 
Disconnect the port forward by pressing CTRL+C in the terminal it's running in. The application can be cleaned up using the following:

```bash
kubectl delete service/simpleservice deployment/sise-deploy
```