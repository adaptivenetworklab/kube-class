# Kubeconfig File

## Understanding the KUBECONFIG

Commands to interact with `kubeconfig` are `kubectl config`. </br>
Key commands are telling `kubectl` which context to use 

```
kubectl config current-context
kubectl config get-contexts
kubectl config use-context <name>
```

You can use the Kubeconfig in different ways and each way has its own precedence. Here is the precedence in order,.

    1. Kubectl Context: Kubeconfig with kubectl overrides all other configs. It has the highest precedence.
    2. Environment Variable: KUBECONFIG env variable overrides current context.
    3. Command-Line Reference: The current context has the least precedence over inline config reference and env variable.

Now let’s take a look at all the **three ways to use the Kubeconfig file**.

## Method 1: Connect to Kubernetes Cluster With Kubeconfig Kubectl Context

To connect to the Kubernetes cluster, the basic prerequisite is the Kubectl CLI plugin. If you dont have the CLI installed, follow the instructions given here.

Now follow the steps given below to use the kubeconfig file to interact with the cluster.

### Step 1: Move kubeconfig to .kube directory.

Kubectl interacts with the kubernetes cluster using the details available in the Kubeconfig file. By default, kubectl looks for the config file in the /.kube location.

Lets move the kubeconfig file to the .kube directory. Replace /path/to/kubeconfig with your kubeconfig current path.

```bash
mv /path/to/kubeconfig ~/.kube
```

### Step 2: List all cluster contexts

You can have any number of kubeconfig in the .kube directory. Each config will have a unique context name (ie, the name of the cluster). You can validate the Kubeconfig file by listing the contexts. You can list all the contexts using the following command. It will list the context name as the name of the cluster.

```bash
kubectl config get-contexts
```

### Step 3: Set the current context

Now you need to set the current context to your kubeconfig file. You can set that using the following command. replace <cluster-name> with your listed context name.

```bash
kubectl config use-context <cluster-name>  
```

For example,

```bash
kubectl config use-context my-dev-cluster
```
### Step 4: Validate the Kubernetes cluster connectivity

To validate the cluster connectivity, you can execute the following kubectl command to list the cluster nodes.

```bash
kubectl get nodes
```
## Method 2: Connect with KUBECONFIG environment variable

You can set the `KUBECONFIG` environment variable with the `kubeconfig` file path to connect to the cluster. So wherever you are using the kubectl command from the terminal, the `KUBECONFIG` env variable should be available. If you set this variable, it overrides the current cluster context.

You can set the variable using the following command. Where `dev_cluster_config` is the `kubeconfig` file name.

```bash
KUBECONFIG=$HOME/.kube/dev_cluster_config
```

## Method 3: Using Kubeconfig File With Kubectl

You can pass the Kubeconfig file with the Kubectl command to override the current context and KUBECONFIG env variable.

Here is an example to get nodes.

```bash
kubectl get nodes --kubeconfig=$HOME/.kube/dev_cluster_config
```

Also you can use,
```bash
KUBECONFIG=$HOME/.kube/dev_cluster_config kubectl get nodes
```

## Clean up

```
kind delete cluster --name dev
kind delete cluster --name prod

```
