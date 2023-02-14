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

## Method 1: Connect with KUBECONFIG environment variable

You can set the `KUBECONFIG` environment variable with the `kubeconfig` file path to connect to the cluster. So wherever you are using the kubectl command from the terminal, the `KUBECONFIG` env variable should be available. If you set this variable, it overrides the current cluster context.

You can set the variable using the following command. Where `dev_cluster_config` is the `kubeconfig` file name.

**Linux:**
```bash
export KUBECONFIG=$HOME/.kube/dev_cluster_config
```
**Windows:**
```bash
$env:KUBECONFIG = "C:\Users\rafli\.kube\rafli-config"
```

## Method 2: Using Kubeconfig File With Kubectl

You can pass the Kubeconfig file with the Kubectl command to override the current context and KUBECONFIG env variable.

Here is an example to get nodes.

```bash
kubectl get nodes --kubeconfig=$HOME/.kube/config
```

## Merging Kubeconfig File

```
# Make a copy of your existing config
$ cp ~/.kube/config ~/.kube/config.bak

# Merge the two config files together into a new config file
$ KUBECONFIG=~/.kube/config:/path/to/new/config kubectl config view --flatten > /tmp/config

# Replace your old config with the new merged config
$ mv /tmp/config ~/.kube/config

# (optional) Delete the backup once you confirm everything worked ok
$ rm ~/.kube/config.bak
```

