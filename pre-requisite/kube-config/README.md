# Different Methods to Connect Kubernetes Cluster With Kubeconfig File

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

```console
mv /path/to/kubeconfig ~/.kube
```

### Step 2: List all cluster contexts

You can have any number of kubeconfig in the .kube directory. Each config will have a unique context name (ie, the name of the cluster). You can validate the Kubeconfig file by listing the contexts. You can list all the contexts using the following command. It will list the context name as the name of the cluster.

```console
kubectl config get-contexts
```

### Step 3: Set the current context

Now you need to set the current context to your kubeconfig file. You can set that using the following command. replace <cluster-name> with your listed context name.

```console
kubectl config use-context <cluster-name>  
```

For example,

```console
kubectl config use-context my-dev-cluster
```
Step 4: Validate the Kubernetes cluster connectivity

To validate the cluster connectivity, you can execute the following kubectl command to list the cluster nodes.

```console
kubectl get nodes
```
## Method 2: Connect with KUBECONFIG environment variable

You can set the `KUBECONFIG` environment variable with the `kubeconfig` file path to connect to the cluster. So wherever you are using the kubectl command from the terminal, the `KUBECONFIG` env variable should be available. If you set this variable, it overrides the current cluster context.

You can set the variable using the following command. Where `dev_cluster_config` is the `kubeconfig` file name.

```console
KUBECONFIG=$HOME/.kube/dev_cluster_config
```

## Method 3: Using Kubeconfig File With Kubectl

You can pass the Kubeconfig file with the Kubectl command to override the current context and KUBECONFIG env variable.

Here is an example to get nodes.

```console
kubectl get nodes --kubeconfig=$HOME/.kube/dev_cluster_config
```

Also you can use,
```console
KUBECONFIG=$HOME/.kube/dev_cluster_config kubectl get nodes
```

# Merging Multiple Kubeconfig Files

Usually, when you work with Kubernetes services like GKE, all the cluster contexts get added as a single file. However, there are situations where you will be given a Kubeconfig file with limited access to connect to prod or non-prod servers. To manage all clusters effectively using a single config, you can merge the other Kubeconfig files to the default `$HOME/.kube/config` file using the supported kubectl command.

Lets assume you have three Kubeconfig files in the `$HOME/.kube/` directory.

    1. config (default kubeconfig)
    2. dev_config
    3. test_config

You can merge all the three configs into a single file using the following command. Ensure you are running the command from the `$HOME/.kube` directory

```console
KUBECONFIG=config:dev_config:test_config kubectl config view --merge --flatten > config.new
```

The above command creates a merged config named `config.new`.

Now rename the old `$HOME.kube/config` file.

```console
 mv $HOME/.kube/config $HOME/.kube/config.old
```

Rename the `config.new` to config.
```console
mv $HOME/.kube/config.new $HOME/.kube/config
```

To verify the configuration, try listing the contexts from the config.
```console
kubectl config get-contexts
```

# Kubeconfig File FAQs

Let’s look at some of the frequently asked Kubeconfig file questions.

## Where do I put the Kubeconfig file?

The default Kubeconfig file location is $HOME/.kube/ folder in the home directory. Kubectl looks for the kubeconfig file using the conext name from the .kube folder. However, if you are using the KUBECONFIG environment variable, you can place the kubeconfig file in a preferred folder and refer to the path in the KUBECONFIG environment variable.

## Where is the Kubeconfig file located?

All the kubeconfig files are located in the .kube directory in the user home directory.That is $HOME/.kube/config

## How to manage multiple Kubeconfig files?

You can store all the kubeconfig files in $HOME/.kube directory. You need to change the cluster context to connect to a specific cluster.


## How to create a Kubeconfig file?

To create a Kubeconfig file, you need to have the cluster endpoint details, cluster CA certificate, and authentication token. Then you need to create a Kubernetes YAML object of type config with all the cluster details.
How to use Proxy with Kubeconfig

If you are behind a corporate proxy, you can use proxy-url: https://proxy.host:port in your Kubeconfig file to connect to the cluster.
