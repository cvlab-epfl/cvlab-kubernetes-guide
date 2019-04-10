
# Kubernetes at CVLab

Other resources on that topic:

* <https://github.com/EPFL-IC/caas>
* <https://github.com/epfml/kubernetes-setup>
* <https://github.com/kcyu2014/cvlab-kubernetes>

If you find a mistake, something is not working, you know a better way to do it, 
or you need a new image to be built, please contact me at *krzysztof.lis@epfl.ch*.

## Overview

Docker *containers* are the processses running on a docker host (that is our server). They use the same operating system as the host, but have their own internal file system and do no see the host's file system.

*Images* are snapshots of that internal file system. For example we installed our libraries in a container and take a snapshot so that we can start new containers from the same base. Images can be made by saving a given containers file system, but usually are specified declaratively with [Dockerfiles](https://docs.docker.com/engine/reference/builder/).

[Kubernetes](https://kubernetes.io/) is a system that organizes running a big number of docker containers on a multi-machine cluster.
The rationale is that Kubernetes will allocate resources when we need to run a job and release them later, leading to a more efficient usage than when machines are assigned to people - we do not pay for the resources when the jobs are not running.


## Setup

To communicate with the Kubernetes server, we need to:

* [install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

* get the config files from IC admins (`user.config`, `user.crt`, `user.key`), copy them to `~/.kube` and rename `user.config` to `config`.

## Pre-built images

I made some base images that should be useful to everyone. It should be easy to start using those, without having to build custom images. 
The user account setup is done through environment variables, so you do not have to place it in your Dockerfile.

[`ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10`](./images/lab-python-ml/Dockerfile) contains CUDA, Pytorch, Tensorflow, OpenCV as well as other commonly used packages.
If you need more, you can extend this and build your own image on top (Dockerfile `FROM`) or let me know that something needs adding.

[`ic-registry.epfl.ch/cvlab/lis/lab-base:cpu`](./images/lab-base/Dockerfile) is the base with just user account setup for cvlabdata mounting, the `:cuda10` version additionally has CUDA installed.

More about images [here](./images).


## Defining your containers

We tell Kubernetes to run our containers by creating Pods. A [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/) is a definition of a group of containers that should be run.

An example pod file is shown in [pods/example-test.yaml](./pods/example-test.yaml).

First we specify the name of the pod - we will use this name to refer to it by different commands. 
```yaml
metadata:
  name: username-example-test
```

Then we say what containers should be running in that pod, most importantly what image to start from and what command to run.

```yaml
spec:
  restartPolicy: Never # once it finishes, do not restart
  containers:
    - name: base-test
      image: ic-registry.epfl.ch/cvlab/lis/lab-base:cpu
      command: ["/opt/lab/setup_and_wait_forever.sh"] 
```

We set the [`restartPolicy`](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)
to `Never` so that once the job is finished, it releases the resources and does not restart.
By default, Kubernetes restarts containers when they finish.
We could also use a Kubernetes [Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/).


Futher we specify the environment variables, for example:

```yaml
env:
  - name: JUPYTER_CONFIG_DIR
    value: "/cvlabdata2/home/lis/kubernetes_example/.jupyter"
  ...
```
The variables concerning users and groups, as well as `volumes` are described in the section about [cvlabdata](#connection-to-cvlabdata).

The `ports` entry is described [later](#network-communication-port-forwarding).


### GPU

To request a GPU, add this to the container:

```yaml
      resources:
        limits:
          nvidia.com/gpu: 1 # requesting 1 GPU
```


### External storage

By default the container only has access to its internal file system. To read or save some data, we will mount the cvlabdata drives.

This is achieved by adding this to your pod configuration (pod is the top-level object):
```yaml
  volumes:
    - name: cvlabsrc1
      persistentVolumeClaim:
        claimName: pv-cvlabsrc1
    - name: cvlabdata1
      persistentVolumeClaim:
        claimName: pv-cvlabdata1
    - name: cvlabdata2
      persistentVolumeClaim:
        claimName: pv-cvlabdata2
```
and this to each of your containers:
```yaml
      volumeMounts:
        - mountPath: /cvlabsrc1
          name: cvlabsrc1
        - mountPath: /cvlabdata1
          name: cvlabdata1
        - mountPath: /cvlabdata2
          name: cvlabdata2
```

#### CVLabData write permissions

To have write permissions to cvlabdata, we need to present our user IDs from the cluster.
Run the `id` command on iccluster, you should get something like this:
```
uid=123456(youruser) gid=11166(CVLAB-unit) groups=....
```

Copy the number from `uid=...` and put it into the pod configuration file:

```yaml
      env:
      - name: CLUSTER_USER
        value: "username" # set this
      - name: CLUSTER_USER_ID
        value: "123456" # set this
      - name: CLUSTER_GROUP_NAME
        value: "CVLAB-unit"
      - name: CLUSTER_GROUP_ID
        value: "11166"
```

In my base containers, these variables are used to setup the user account with the following [script](./images/lab-base/setup_steps/10_cluster_user.sh) when the container start up.

The images which have this feature so far are:  

* `ic-registry.epfl.ch/cvlab/lis/lab-base:cpu` 
* `ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10`
* `ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10`
* and anything built on top of those

### Startup Command
The `command` field specifies the program to run when the container starts. Also when this command finishes, the container will shut down.

Therefore, if we want the container to wait and let us connect to it, we can specify the command as:

```yaml
command: ["sleep", "1h"]
```

or if you are using my premade images:
```yaml
# sets up the user account and then waits for the time specified in $AUTO_SHUTDOWN_TIME
command: ["/opt/lab/setup_and_wait.sh"]
```

Please remember that this will run and occupy the resources until you explicitly delete the pod or the time runs out.


For example running a python program:
```yaml
command: ["python", "some_program.py", "--option", "val"]
```

In the premade images with user setup:
```yaml
# run a python job
command:
  - "/opt/lab/setup_and_run_command.sh"
  - "cd /cvlabdata2/home/lis/kubernetes_example && python job_example.py"
```

```yaml
# start a jupyter server
command:
  - "/opt/lab/setup_and_run_command.sh"
  - "jupyter lab --ip=0.0.0.0 --no-browser --notebook-dir=/cvlabdata2/home/lis/kubernetes_example"
```

You can run those examples in `/cvlabdata2/home/lis/kubernetes_example`, I will clear it out periodically.

## Running the containers

We list, start and stop pods using the *kubectl* command

* `kubectl get pods` - list pods which currently exist
* `kubectl create -f pod_definition_file.yaml` - create a new pod according to your specification
* `kubectl delete pod pod_name` - delete your pod (make sure you delete containers you don't use anymore)
* `kubectl describe pod pod_name` - show information about a pod, including the output logs, useful to diagnose why it isn't working.
* `kubectl logs pod_name` - output logs from a pod
* `kubectl describe quota --namespace=cvlab` - show how many GPUs are used

Once a pod is running, we can connect to it and run commands inside:
```
kubectl exec -it pod_name -- /bin/bash
```

This will be executed as the `root` user, so switch to your user which can write on cvlab drives:
```
su youruser -c /bin/bash
```



## Network communication - port forwarding

See the example [pod configuration for jupyter](./pods/example-jupyter.yaml).
To connect to our container over the network, first we need to expose the ports in our container configuration:

```yaml
ports:
- containerPort: 8888
  name: jupyter
```

One the container with exposed ports is running, we will make a tunnel from our local computer's port to the container's port 
([Kubernetes port forwarding](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)).

```
kubectl port-forward mypod local_port:container_port
```

For example for jupyter:

```
kubectl port-forward lis-example 8001:8888
```

Then we can open jupyter at localhost:8001.
The password in the example config is `hello`.

Alternatively a [load balancer](https://github.com/EPFL-IC/caas#step-three-accessing-pods-from-outside-of-the-cluster) can be used to make the container accessible through the network.


