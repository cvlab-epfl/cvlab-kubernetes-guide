# ICCluster at CVLab

If you find a mistake, something is not working, you know a better way to do it,
or you need a new image to be built, please let me know or open an issue here.
*\- Kris*

## Quick start with RunAI

### Install RunAI CLI

Things to download and put in $PATH:

* runai [linux](http://runai-epfl.iccluster.epfl.ch/cli/linux), [mac](http://runai-epfl.iccluster.epfl.ch/cli/darwin)
* helm
    https://github.com/helm/helm/releases
    or
    brew install helm
* kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Make sure the binaries have permission to execute (e.g. `chmod +x some/place/runai`).
More on the CLI installation:
https://docs.run.ai/Administrator/Researcher-Setup/cli-install/

### Login

* Find your user/password in emails or ask IC-admins if you have not received it. [Asking for access](https://icitdocs.epfl.ch/display/clusterdocs/Getting+Started+with+RunAI+SAML). New logins seem possible through a web link too so perhaps password is not mandatory.
* Connect to <https://app.run.ai> and you make sure the user/password/web-authentication works.
* Download the config file: <https://icitdocs.epfl.ch/download/attachments/23986177/config?version=1&modificationDate=1656340636000&api=v2> and place it in `~/.kube/`. If the download link changes, it is likely to be listed [here](https://icitdocs.epfl.ch/display/clusterdocs/Getting+Started+with+RunAI+SAML).
* In a console, to login to RunAI, run: `runai login`
* In a console, configure your default project with: `runai config project cvlab-yourname`
* Test if you see the lab's jobs `runai list jobs`

### Quick-start scripts
We have scripts for launching jobs with sensible defaults which should serve you for most use cases.


#### Script setup

* Download scripts: [runai_one.sh](script/runai_one.sh), [runai_interactive.sh](script/runai_interactive.sh)

* Edit the scripts to fill in `CLUSTER_USER`, `CLUSTER_USER_ID` values for your EPFL cluster account, and `MY_WORK_DIR` if you want to change the directory where the job runs.


#### Batch job
Submit jobs running a command with `runai_one.sh`. These jobs have *training* priority.

- `bash runai_one.sh job_name num_gpu "command"`

- `bash runai_one.sh name-hello-1 1 "python hello.py"`  
creates a job named `name-hello-1`, **uses 1 GPU**, enters `MY_WORK_DIR` directory and runs `python hello.py`  

- `bash runai_one.sh name-hello-2 0.5 "python hello_half.py"`  
creates a job named `name-hello-2`, receives **half of a GPUs memory** (2 such jobs can fit on one GPU!), enters `MY_WORK_DIR` directory and runs `python hello_half.py`


#### Interactive session
Submit an interactive job with `bash runai_interactive.sh`, the job will be named `yourname-inter` and
has **interactive** priority, uses 0.5 GPU (customizable), starts a jupyter server at port 8888 with default password `hello`, runs for 8 hours.

- Connect to the jupyter server: `kubectl port-forward yourname-inter-0-0 8888:8888`, open [localhost:8888](http://localhost:8888), default password is `hello`.
- Connect in the console: `runai bash yourname-inter`.
- Once the interactive job has finished, delete it to make starting a new one possible: `runai delete yourname-inter`

#### Remote work with `vscode`
There is a [separate tutorial](doc/vscode.md) on setting `vscode` up to work directly on the running node, allowing for easy (and GPU-accelerated) execution and debugging.

### Detailed job management

* Submit jobs with `runai submit` [(doc)](https://docs.run.ai/Researcher/cli-reference/runai-submit/).  
Our [runai submit script](script/runai_one.sh) uses it in the following way:

```bash

runai_project="cvlab-$CLUSTER_USER" # per-user runai projects now

runai submit $arg_job_name \
	-i $MY_IMAGE \
	--gpu $arg_gpu \
	--pvc runai-$runai_project-cvlabdata1:/cvlabdata1 \
	--pvc runai-$runai_project-cvlabdata2:/cvlabdata2 \
	--pvc runai-$runai_project-cvlabsrc1:/cvlabsrc1 \
	--large-shm \
	-e CLUSTER_USER=$CLUSTER_USER \
	-e CLUSTER_USER_ID=$CLUSTER_USER_ID \
	-e CLUSTER_GROUP_NAME=$CLUSTER_GROUP_NAME \
	-e CLUSTER_GROUP_ID=$CLUSTER_GROUP_ID \
	-e TORCH_HOME="/cvlabsrc1/cvlab/pytorch_model_zoo" \
	--command -- /opt/lab/setup_and_run_command.sh "cd $MY_WORK_DIR && $arg_cmd"
```

**Choice of docker images**: 
The mechanism which sets up the user/group will not work on docker images built from scratch, because it uses [these setup scripts](./images/lab-base).
The details of our images are in the [images](./images) section of this repository.
You are welcome to use these images or build upon them.
For direct use I recommend `ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10` as it has fairly modern versions of various scientific libraries.

**Volume mounts**: The default volume mounts in the script are for CVLAB (cvlabdata volumes). Please change them if you are in a different lab.

**Training vs interactive**: By default [jobs are *training* mode](https://docs.run.ai/Researcher/Walkthroughs/walkthrough-train/), which means they can use GPUs beyond the lab's quota of 28, but can be stopped and restarted (so its worth checkpointing etc). Jobs can be made *interactive* (non-preemptible) with the `--interactive` option of `runai submit`, but they are stopped after 12 hours, and there is a limited number of those allowed in the lab, so please do not create too many simultaneously.


### Manage and connect

* List jobs in the lab: `runai list jobs`

* Find out the status of your job `runai describe job jobname`

* Stop running jobs with `runai delete job jobname`. Also if you want to submit another job with the same name, you need to delete the existing one which occupies the name.

* View logs `runai logs jobname`. Add `--tail 64` to see 64 latest lines (or other number)

* Run an interactive console inside the container `runai bash jobname`.

* Forward ports between the container and your machine, for example for jupyter:
`kubectl port-forward jobname-0-0 8888:8888`


### Asking the admins for help

The cluster machines sometimes get stuck and need to be restarted, or there are bugs in RunAI.
In these cases, we need to ask the ICIT admins for help. 
To localize the problem, they need good diagnostic information from you.

The [detailed procedure can be found here](https://icitdocs.epfl.ch/display/clusterdocs/Good+hints+to+open+a+ticket). Here is the copy of this procedure, so that you may view it outside of the EPFL network:

**To open a ticket, please send an email to support-icit@epfl.ch.**

* Chose an explicit **subject**
* qualify your ticket by providing all the information useful to resolve your issue
* attach your **yaml file** or the **runai command** used to start your job
* attach job/pod's **log information** (replace `<lab>` by your lab name)
  * find your job/pod:
  ```
  $ runai list job -p <lab>
  $ kubectl get pods -n runai-<lab>
  ```
  * get job/pod's description
  ```
  $ runai describe job <job name> -p <lab>
  $ kubectl describe pod <pod name> -n runai-<lab>
  ```
  * get job/pod's log
  ```
  $ runai logs pod name> -p <lab>
  $ kubectl logs <pod name> -n runai-<lab>
  ```
* provide others log messages you can have

## Overview

Docker *containers* are the processses running on a docker host (that is our server). They use the same operating system as the host, but have their own internal file system and do no see the host's file system.

*Images* are snapshots of that internal file system. For example we installed our libraries in a container and take a snapshot so that we can start new containers from the same base. Images can be made by saving a given container's file system, but usually are specified declaratively with [Dockerfiles](https://docs.docker.com/engine/reference/builder/).

[Kubernetes](https://kubernetes.io/) is a system that organizes running a big number of docker containers on a multi-machine cluster.
The rationale is that Kubernetes will allocate resources when we need to run a job and release them later, leading to a more efficient usage than when machines are assigned to people - we do not pay for the resources when the jobs are not running.

## Pre-built images

I made some base images that should be useful to everyone. It should be easy to start using those, without having to build custom images.
The user account setup is done through environment variables, so you do not have to place it in your Dockerfile.

[`ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda11`](./images/lab-python-ml/Dockerfile) contains CUDA, PyTorch, Tensorflow, OpenCV, [GluonCV](https://gluon-cv.mxnet.io/), [Detectron2](https://github.com/facebookresearch/detectron2), [PyTorch3D](https://pytorch3d.org/) as well as other commonly used packages.
If you need more, you can extend this and build your own image on top (Dockerfile `FROM`) or let me know that something needs adding.

[`ic-registry.epfl.ch/cvlab/lis/lab-pytorch:cuda11`](./images/lab-pytorch/Dockerfile) - smaller image without TF or Gluon.

[`ic-registry.epfl.ch/cvlab/lis/lab-base:cpu`](./images/lab-base/Dockerfile) is the base with just user account setup for cvlabdata mounting, the `:cuda10` version additionally has CUDA installed.

More about images [here](./images).

The GPUs we have at the cluster work faster with [half-precision training](https://pytorch.org/blog/accelerating-training-on-nvidia-gpus-with-pytorch-automatic-mixed-precision/).


## External storage

By default the container only has access to its internal file system. To read or save some data, we will mount the cvlabdata drives.

This is achieved by adding this to your pod configuration (pod is the top-level object):

``` yaml
  volumes:
    - name: cvlabsrc1
      persistentVolumeClaim:
        claimName: runai-cvlab-yourname-cvlabsrc1
    - name: cvlabdata1
      persistentVolumeClaim:
        claimName: runai-cvlab-yourname-cvlabdata1
    - name: cvlabdata2
      persistentVolumeClaim:
        claimName: runai-cvlab-yourname-cvlabdata2
```

and this to each of your containers:

``` yaml
      volumeMounts:
        - mountPath: /cvlabsrc1
          name: cvlabsrc1
        - mountPath: /cvlabdata1
          name: cvlabdata1
        - mountPath: /cvlabdata2
          name: cvlabdata2
```

### CVLabData write permissions

To have write permissions to cvlabdata, we need to present our user IDs from the cluster.
Run the `id` command on iccluster, you should get something like this:

```
uid=123456(youruser) gid=11166(CVLAB-unit) groups=....
```

Copy the number from `uid=...` and put it into the pod configuration file:

``` yaml
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
* `ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src`
* `ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38src`
* and anything built on top of those

## Startup Command

The `command` field specifies the program to run when the container starts. Also when this command finishes, the container will shut down.

For example running a python program:

``` yaml
command: ["python", "some_program.py", "--option", "val"]
```

In the premade images with user setup:

``` yaml
# run a python job
command:
  - "/opt/lab/setup_and_run_command.sh"
  - "cd /cvlabdata2/home/lis/kubernetes_example && python job_example.py"
```

``` yaml
# start a jupyter server
command:
  - "/opt/lab/setup_and_run_command.sh"
  - "timeout 4h jupyter lab --ip=0.0.0.0 --no-browser --notebook-dir=/cvlabdata2/home/lis/kubernetes_example"
  # Timeout will ensure the pod closes after some time,
  # so we don't risk leaving it running forever.
```

You can run those examples in `/cvlabdata2/home/lis/kubernetes_example`, I will clear it out periodically.


### Timeout

If a process does not finish by itself, I recommend limiting its lifetime with [timeout](https://www.tecmint.com/run-linux-command-with-time-limit-and-timeout/). The following command will automatically shut down Jupyter after 4 hours:

```
timeout 4h jupyter lab --ip=0.0.0.0 --no-browser --notebook-dir=/cvlabdata2/home/lis/kubernetes_example"
```


### Connecting an interactive console to the container

Once a pod is running, we can connect to it and run commands inside:

```
kubectl exec -it pod_name -- /bin/bash
```

This will be executed as the `root` user, so switch to your user which can write on cvlab drives:

```
su youruser -c /bin/bash
```

This can be combined into a single convenient command:

```
kubectl exec -it pod-name -- bash -c "su youtuser -c tmux"
```

### Diagnosing problems

If the job is not running as intended, you can see its status:

```
kubectl describe pod/pod_name
```

and check for errors by viewing the the output of your process:

```
kubectl logs pod_name
```


## Running multiple experiments in one container

The GPUs in the Kubernetes cluster usually have `32GB` of memory, so compared to the previous 12GB GPUs, they should be capable of running 2 or 3 experiments of usual size at once.

The script below shows a simple way to run several experiments at once.
The commands will run in parallel, the container will finish when the last one finishes.

``` bash
# my_job.sh
python task_1.py &
python task_2.py &
bash task_3.sh &
# the jobs will run in parallel
# the container will finish when the last one finishes
wait
```

## Network communication - port forwarding

See the example [pod configuration for jupyter](./pods/example-jupyter.yaml).
To connect to our container over the network, first we need to expose the ports in our container configuration:

``` yaml
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

To shut down jupyter (and the container with it) from the web interface:

* JupyterLab: select *File -> Quit* from the menu in the top-left
* Jupyter Notebook: press the *Quit* button in the top right

Jupyter will run forever if we do not close it. Therefore I recommend limiting it with [timeout](https://www.tecmint.com/run-linux-command-with-time-limit-and-timeout/). The following command will automatically shut down Jupyter after 4 hours:

```
timeout 4h jupyter lab --ip=0.0.0.0 --no-browser --notebook-dir=/cvlabdata2/home/lis/kubernetes_example"
```

Alternatively a [load balancer](https://github.com/EPFL-IC/caas#step-three-accessing-pods-from-outside-of-the-cluster) can be used to make the container accessible through the network.
