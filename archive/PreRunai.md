
# Pre RunAi

## Setup

To communicate with the Kubernetes server, we need to:

* [install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* get the config files from [IC admins](https://www.epfl.ch/schools/ic/it/en/it-service-ic-it/) (`user.config`, `user.crt`, `user.key`), copy them to `~/.kube` and rename `user.config` to `config`.

## Defining your containers

We tell Kubernetes to run our containers by creating Pods. A [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/) is a definition of a group of containers that should be run.

An example pod file is shown in [pods/example-test.yaml](./pods/example-test.yaml).

First we specify the name of the pod - we will use this name to refer to it by different commands.
Please also provide your user name and desired priority of the job, these are used for resource allocation.

``` yaml
metadata:
  name: username-example-test
  labels:
    user: your-username
    priority: "1" # job with higher priority number takes precedence
```

Then we say what containers should be running in that pod, most importantly what image to start from and what command to run.

``` yaml
spec:
  restartPolicy: Never # once it finishes, do not restart
  containers:
    - name: base-test
      image: ic-registry.epfl.ch/cvlab/lis/lab-base:cpu
      command: ["/opt/lab/setup_and_wait.sh"]
```

We set the [`restartPolicy`](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)
to `Never` so that once the job is finished, it releases the resources and does not restart.
By default, Kubernetes restarts containers when they finish.
We could also use a Kubernetes [Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/).

Futher we specify the environment variables, for example:

``` yaml
env:
  - name: JUPYTER_CONFIG_DIR
    value: "/cvlabdata2/home/lis/kubernetes_example/.jupyter"
  ...
```

The variables concerning users and groups, as well as `volumes` are described in the section about [cvlabdata](#connection-to-cvlabdata).

The `ports` entry is described [later](#network-communication-port-forwarding).

### GPU

To request a GPU, add this to the container:

``` yaml
      resources:
        limits:
          nvidia.com/gpu: 1 # requesting 1 GPU
```

It may happen that the GPUs are all occupied, you can check how many are used:

```
kubectl describe quota --namespace=cvlab
```

## Running the containers

We list, start and stop pods using the *kubectl* command

* `kubectl get pods` \- list pods which currently exist
* `kubectl get pods --field-selector=status.phase=Running` \- list pods which are currently running
* `kubectl create -f pod_definition_file.yaml` \- create a new pod according to your specification
* `kubectl delete pod pod_name` \- delete your pod \(make sure you delete containers you don't use anymore\)
* `kubectl describe pods/pod_name` \- show information about a pod\, including the output logs\, useful to diagnose why it isn't working\.
* `kubectl logs pod_name` \- output logs from a pod
* `kubectl describe quota --namespace=cvlab` \- show how many GPUs are used


## Resource allocation in CVLAB

We want to ensure that everyone can use at least one GPU.
We order the jobs and the position in the queue will decide which jobs will be allowed to run in case we have more requests than available resources.

* A job using one person's 1st GPU has precedence over any person's 2nd GPU job. A 2nd GPU job is above any 3rd GPU job and so on.
* Among the jobs of a single user, we order them according to user-set priority (in the label `priority`) with higher numbers being more important: priority `+1` is before priority `-1`, the default is 0.
If priority is equal, the earlier job takes precedence.

The queue is displayed at [http://iccvlabsrv13.iccluster.epfl.ch:5336/](http://iccvlabsrv13.iccluster.epfl.ch:5336/).
If all of the 30 GPUs are occupied, and you want to run your **1st** job, you can kill the last job in the queue. In that case please notify the owner.

Please remember to specify your user name and priority in the pod config.

``` yaml
metadata:
  name: username-example-test
  labels:
    user: your-username
    priority: "1" # job with higher priority number takes precedence
```

