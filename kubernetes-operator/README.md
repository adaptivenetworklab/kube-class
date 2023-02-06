# Kubernetes Operator

## What is a Kubernetes Operator?

A Kubernetes Operator is an abstraction for deploying non-trivial applications on top of Kubernetes, behind Kubernetes APIs. 

The Kubernetes Operator attempts to wraps the logic for deploying and operating complex non-trivial application using Kubernetes constructs and thus making life easy for the Ops engineering team.

The Kubernetes Operators adds a new custom resource (CR) to the Kubernetes cluster and along with it also introduces a new component that continuously monitors and maintains resources of this new type.

So, in summary, making an Operator actually means -

    Creating a CRD and
    Providing a program that runs in a loop watching the CRs of that kind CRD.

What the Operator does in response to changes in the CR is specific to the application the Operator manages.
Setting up the context

Instead of the usual hello world alike example, lets instead take a real world operator for our hands on. The one am referring to here is kube-green.

## Kube-Green

Kube-green is a very noble open source project which aims towards lessening the CO2 footprint of Kubernetes clusters & thus potentially helping towards the noble cause of reducing the global warming.

Kube-green operator introduces -

    A Custom Resource Definition (CRD) called “sleepinfos.kube-green.com” and
    A new Custom Resource Kind called as “SleepInfo”.

You can find this CRD definition from their GitHub page [link](https://github.com/kube-green/kube-green/blob/main/config/crd/bases/kube-green.com_sleepinfos.yaml).

```yaml
apiVersion: v1
items:
- apiVersion: kube-green.com/v1alpha1
  kind: SleepInfo
  metadata:
    name: sleep-test
    namespace: sleepme
  spec:
    excludeRef:
    - apiVersion: apps/v1
      kind: Deployment
      name: do-not-sleep
    sleepAt: '*:*/5'
    wakeUpAt: '*:*/7'
    weekdays: '*'
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```


In short, through the above CR configuration, barring “do-not-sleep” pod(s), all other pod(s) will sleep every 5th minute & wake up every 7th minute and this is for all days of the week. 

Learning around all the available supported features of Kube-green is not in the scope of this lab. However, if you are keen in learning more then do check the available documentations over here.

## Operator deployment

As a first step, we will install the Operator Lifecycle Manager (OLM) in our Kubernetes cluster. For now, the only thing you should be aware of is that the OLM manages the operators running on the cluster. We will cover OLM in-depth in a separate lab. It is out of scope for this lab.

```bash
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.21.2/install.sh | bash -s v0.21.2
```

Next, install the kube-green operator. This Operator will be installed in the “operators” namespace and will be usable from all namespaces in the cluster.

```bash
kubectl create -f https://operatorhub.io/install/kube-green.yaml
```

Well, lets see the resources the kube-green operator installation has ended up creating in our cluster.

```bash
kubectl get all -n operators
```

## Using the operator

Now that the operator has been deployed successfully, lets deploy a sample application for demonstrating the usage of the kube-green operator. This sample application will act as resources for demonstrating the capabilities of kube-green.

First, lets create a namespace for our sample application. Subsequently, we will deploy 3 applications in the newly create namespace.

```bash
kubectl create ns sleepme
```

```bash
kubectl -n sleepme create deploy echo-service-replica-1 --image=davidebianchi/echo-service
```

```bash
kubectl -n sleepme create deploy do-not-sleep --image=davidebianchi/echo-service
```
```bash
kubectl -n sleepme create deploy echo-service-replica-4 --image=davidebianchi/echo-service --replicas 4
```

You should have 6 pods running in the namespace.

```bash
kubectl get pods -n sleepme
```

Next, we will create a SleepInfo CR. Remember, we have shortly visited it sometime back but now we will take it to use for our test scenario.

Consider the following configuration for our demonstration -

    echo-service-replica-1 sleeps at every 2 minutes and wakes up at every 3rd minute.
    all replicas of echo-service-replica-4 will sleeps at every 2 minutes and wakes up at every 3rd minute.
    do-not-sleep pod will never sleep.

Applying this SleepInfo CR in our cluster -

```bash
cat <<EOF | kubectl -nsleepme apply -f -
apiVersion: kube-green.com/v1alpha1
kind: SleepInfo
metadata:
  name: sleep-test
spec:
  weekdays: "*"
  sleepAt: "*:*/2"
  wakeUpAt: "*:*/3"
  excludeRef:
    - apiVersion: "apps/v1"
      kind:       Deployment
      name:       do-not-sleep
EOF
```

Verify only 1 pod instance of "do-not-sleep" is active due to the above configuration (refer sleepAt config above) -

```bash
kubectl get pods -n sleepme
```

Wait for sometime (depending upon your wakeUpAt configuration value) and verify that now all the 6  pod instances are back -

```bash
kubectl get pods -n sleepme -w
```
