<!-- omit in toc -->
# Intro to Kubernetes operators demo
[![Build Status](https://travis-ci.org/AAbouZaid/intro-to-k8s-operators-demo.svg?branch=master)](https://travis-ci.org/AAbouZaid/intro-to-k8s-operators-demo)

This is a pretty simple demo but beyond "hello world" for "Introduction to Kubernetes Operators" session.

**Note:** This Kubernetes operator is just for demo purposes, so it's not for real use. For production, use [Argo Rollouts](https://argoproj.github.io/argo-rollouts/).

<!-- omit in toc -->
## ToC
- [Intro](#intro)
  - [The idea](#the-idea)
  - [How it's created](#how-its-created)
- [Install the operator](#install-the-operator)
- [Usage](#usage)
- [Next steps](#next-steps)
  - [Structural schema](#structural-schema)
  - [Metrics](#metrics)
  - [Extend](#extend)

## Intro

### The idea
By default Kubernetes has 2 update strategies, "Recreate" or "RollingUpdate. “RollingUpdate” is the default.

However, Kubernetes doesn't have a way to control the deployment, e.g. canary deployment style.

So this operator demonstrates how to extend Kubernetes functionality natively by adding a new resource kind called `Deployer` to provide more deployment styles.

<p>
Here is a visual overview how this operator works:
<div class="separator" style="clear: both; text-align: center; padding: 1em 0"><a href="https://1.bp.blogspot.com/-FlFVB7qIYWI/X3IBGcao17I/AAAAAAAAcu0/gVDno7zoQxc7aE8DfTYQsbzkDn5hCQimACLcBGAsYHQ/s1600/ansible-based-k8s-operator-overview-v1.1.gif" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" src="https://1.bp.blogspot.com/-FlFVB7qIYWI/X3IBGcao17I/AAAAAAAAcu0/gVDno7zoQxc7aE8DfTYQsbzkDn5hCQimACLcBGAsYHQ/s640/ansible-based-k8s-operator-overview-v1.1.gif" width="640" height="384" data-original-width="1600" data-original-height="961" /></a></div>
</p>

### How it's created
This is an Ansible based operator using [Operator-SDK](https://sdk.operatorframework.io/docs/installation/) which provides 3 types of Kubernetes operators ... Helm, Ansible, and Go.

Here steps how this operator was built (no need to do that to use the operator).

- Init operator structure:
  ```
  $ operator-sdk new deployer-operator            \
      --api-version="deploy.example.com/v1alpha1" \
      --kind=Deploy                               \
      --type=ansible
  ```
- A playbook with just [1 role](roles/deployer) which has the logic.
- A [watches.yaml](watches.yaml) file which watches 1 CustomResource events.

For more details about building Ansible based operators, please check [official user guide](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md).


## Install the operator

The following steps are meant to try the operator locally using [Minikube](https://minikube.sigs.k8s.io/). Also [Operator SDK CLI](https://github.com/operator-framework/operator-sdk/blob/master/doc/user/install-operator-sdk.md) is needed for build steps.

- Start minikube:
  ```
  $ minikube start
  ```
- Export minikube vars so operator image will built on minikube machine.
  ```
  $ eval $(minikube docker-env)

  # Verify that docker client can communicate with minikube docker daemon.
  # This command should return "Name: minikube".
  $ docker info | grep minikube
  ```
- Build docker image for the operator.
  ```
  $ operator-sdk build deployer-operator:v0.0.1
  ```
- First, add the `CustomResourceDefinition`:
  ```
  $ kubectl apply -f deploy/crds/deploy.example.com_deployers_crd.yaml
  ```
- Then, install the operator to your K8s cluster.
  ```
  $ kubectl apply -f deploy
  ```

Now we are ready to test our new resource.


## Usage

Now we can add a new resource with kind `Deployer`:

```
apiVersion: deploy.example.com/v1alpha1
kind: Deployer
metadata:
  name: nginx
spec:
  type: canary
  deployment:
    name: nginx
    namespace: default
    image: nginx
    version: 1.7.7
    labels:
      app: nginx
      operator: deployer
    replicas: 10
  steps:
    - percent: 10
      sleep: 60
    - percent: 30
      sleep: 30
    - percent: 60
      sleep: 30
    - percent: 100
```

Let's apply that manifest and it will be explained in a min.
```
$ kubectl apply -f deploy/crds/deploy.example.com_v1alpha1_deployer_cr.yaml
```

Then make sure the `deployer` is there:
```
$ kubectl get deployer

NAME    AGE
nginx   14s
```

If there is no previous version, it will just deploy Nginx with version `1.7.7` and 10 replicas. You can watch the new deployment:
```
$ kubectl get deploy

NAME                READY   UP-TO-DATE   AVAILABLE   AGE
deployer-operator   1/1     1            1           1h21m
nginx-1.7.7         10/10   10           1           33s
```

\---

Now let's try the actual canary functionality, so change the version in the `Deployer` manifest file from `1.7.7` to `1.7.8` and apply again.

**The operator will do the following:**
- Deploy new Nginx version `1.7.8` with `zero` pods.
- Doing the 4 steps as described above.
  - Scale up new deployment to `1 pod` (10% of 10), and scale down old version to 9 (90% of 10), then wait `60 seconds`.
  - Scale up new deployment to `3 pods`, and scale down old version to 7, then wait `30 seconds`.
  - Scale up new deployment to `6 pods`, and scale down old version to 4, then wait `30 seconds`.
  - Scale up new deployment  to `10 pods` (100% of 10), and scale down old version to 0.
- Finally it will delete the old deployment `1.7.7`.

You can view operator logs during that process using:
```
$ kubectl logs -f -l name=deployer-operator -c ansible
$ kubectl logs -f -l name=deployer-operator -c operator
```

You can watch the `deployer` status which will be changed based on the current step:
```
$ kubectl describe deployer nginx
[...]
Status:
  Conditions:
    Last Transition Time:  2020-01-11T22:33:00Z
    Message:               Running reconciliation
    Reason:                Running
    Status:                True
    Type:                  Running
  Progress:
    Percentage:  60% has been deployed
    Step:        no. 3
    Wait:        30s till next step
```

You can also watch the `deployments` in action. For example this the deployment state at 3rd step, where 60% of new deployment is taking a place.
```
$ kubectl get deploy -w

NAME                READY   UP-TO-DATE   AVAILABLE   AGE
deployer-operator   1/1     1            1           1h31m
nginx-1.7.7         4/4     4            4           7m31s
nginx-1.7.8         6/6     6            6           2m24s
```

## Next steps

### Structural schema
Right now we can put whatever key/value under `spec` section in the CR, that's because there is no schema specified in the CustomResourceDefinition.

That could make some problems later if someone defined the wrong values. For example, the operator above expects `steps` section to be a "list", if it's a "dict", the Ansible play book will fail!

That's why it's important [to specify a structural schema](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#specifying-a-structural-schema) for CustomResourceDefinitions.

### Metrics
Check the operator metrics which are exposed by default by operator-sdk for any operator.
```
$ kubectl port-forward svc/deployer-operator-metrics 8383 8686
```

Then you can access the [metrics](https://github.com/operator-framework/operator-sdk/blob/master/doc/user/metrics/README.md):
```
http://localhost:8383/metrics
http://localhost:8686/metrics
```

### Extend
Try to extend this operator functionalities like:
- Add more options to each `step` like checking Prometheus metrics, posting step status on Slack, or calling a webhook (you can use [webhook.site](https://webhook.site/) for testing).
- Use Ansible's [Helm module](https://docs.ansible.com/ansible/latest/modules/helm_module.html) to install Nginx instead J2 template file.
