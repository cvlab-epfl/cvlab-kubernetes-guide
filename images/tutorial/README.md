# Building your own images
Docker images are snapshots of operating system configuration, including all installed software, global variables, etc. It's very convenient for enabling multiple users to use the same machines (cluster) for their individual purposes, without problems like version conflicts. This document describes how to build and customize these OS definitions.

## Do I need a custom image?
Many of us will be fine with a basic setup enabling PyTorch and do not need further customization. Building docker images is somewhat time consuming and certainly not worth re-doing just because you decided to add [`tqdm`](https://pypi.org/project/tqdm/) to your project. The reasons to use a custom image:

* You need a specific OS version (eg. Ubuntu 18.04 and not newer)
* You need a specific large library (for example you use JAX instead of PyTorch)
* Your project involves a large dependancy which takes a while to compile or install ([colmap](https://github.com/colmap/colmap), [pytorch3d](https://pytorch3d.readthedocs.io/en/latest/), etc).
* You finished a project and want to publish it in a maximally reproducible way, saving a snapshot of all dependencies (in this case do install all of them, including `tqdm`) 

Otherwise you're probably better off re-installing the minor dependencies each time you create a container by creating `requirements.txt` and executing `pip install -r requirements.txt` as the first command in your job (see the last section of this document on `$PIP_CACHE_DIR`).

## Setup
### Environment
Building docker images involves substantial downloads/uploads and RAM usage so it's most convenient to do it at `iccvlabsrv23.iccluster.epfl.ch`. Simply SSH to the node with 

```
ssh gaspar@iccvlabsrv23.iccluster.epfl.ch
```

Alternatively, you can install docker on your computer:
```
sudo apt install docker.io
```

`docker` may need `sudo` to operate correctly.

### Image repository login
In any case you need to log in to our docker image repository, which is where `runai` can download images from. The repository is a cloud storage location referenced when you submit your jobs with
```
runai submit $JOB_NAME -i ic-registry.epfl.ch/cvlab/your_gaspar/image_name
```

To log in you use the following:
```
docker login ic-registry.epfl.ch
```

The user name and password are your gaspar/gaspar_password. At this point you should be able to execute the `build` script inside this directory to build your two images.

## Dockerfiles

An image is specified by a directory containing a file named *Dockerfile*.
Here is the [Dockerfile documentation](https://docs.docker.com/engine/reference/builder/).

At the beginning, we say on top of which file we build:
```
FROM base_image_tag
```

Other common operations are:

* run commands with `RUN`:
```
RUN apt-get update \
	&& apt-get --no-install-recommends -y install sudo htop tmux locate mc less \
	&& apt-get clean
```

* set environment variables with `ENV`:
```
ENV AUTO_SHUTDOWN_TIME 1h
```

* copy files from the current directory
```
COPY local_file /opt/lab/file_inside_image
```

### Existing images

You can view the existing images available in our repository at <https://ic-registry.epfl.ch/> (login to see CVLab's images). 
There are also many publicly available images at the [Docker Hub](https://hub.docker.com/search?q=&type=image), with the [NVIDIA CUDA](https://hub.docker.com/r/nvidia/cuda/tags) images being of particular interest to us. These are usually the starting point for our own images.

## Extending the image
Please see the extensively commented [Dockerfile](./base/Dockerfile) to see how a single image is defined and [the build script](./build) to see how to build it, as well as how to arrange to build mutually dependant images.

## Best practices
Most online tutorials will tell you to do everything you can to **reduce the size** of the resulting images. This is crucial in the common usecase of `docker` for serving web services in enterprise cloud like AWS, but less important for us, because we keep using the same images on the same machines. Still, it's worth keeping the image size small. 

Docker works by adding consecutive "layers" on top of the previous image (delta encoding like in `git`). Each command in a `Dockerfile` defines a new layer. This means that writing

```
RUN apt-get install very-big-package
RUN apt-get remove very-big-package
```

will result in a large image even though we end up without `very-big-package`. There are two common cases when a problem like this occurs: programs utilizing caches and ones which require compilation.

### Caches
Many operations result in creating various kinds of caches, which unless cleaned **in the same command** will persist and make the image bigger. This is why all python installs use
```
pip install --no-cache-dir some-package
```
Similarly, this is the reason for the shenanigans on line 9 of [base Dockerfile](./base/Dockerfile): 
```
RUN sed 's@archive.ubuntu.com@ubuntu.ethz.ch@' -i /etc/apt/sources.list \
        && apt-get update \
	&& apt-get --no-install-recommends -y install \
		sudo htop tmux screen locate \
		mc less vim git ripgrep tree psmisc \
		curl wget ca-certificates \
		xz-utils p7zip-full \
		cmake openssh-server \
		hdf5-tools h5utils \
		libgomp1 ninja-build \
                python3 python3-pip python3-dev \
		build-essential libncursesw5-dev libreadline-dev \
		libssl-dev libgdbm-dev libc6-dev libsqlite3-dev libffi-dev libdb-dev \
		libbz2-dev liblzma-dev zlib1g-dev \
		libexpat1-dev uuid-dev \
	&& ldconfig \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
```

We need to download a list of available packages to be able to run `apt-get install` but we do not want to keep these lists in the final image, so we use the `&&` operator to merge multiple commands and remove the package list before the end of the `RUN` command.

### Compiled software
Another case is software which needs to be compiled - this usually involves a bunch of extra components like the compiler and dependencies which you will not need in your final image. In this case, you may benefit from [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/):
this involves creating a temporary container with the build tools where the compilation takes place, then we only copy the results of the compilation to the output image.
This saves space in the output image and allows the build process to be cached.

### PIP_CACHE_DIR
By default, dependencies which are installed with `pip` everytime you start a job will have to be re-downloaded each time. A way to save time and bandwidth is to utilize the `pip` cache. By default the cache is somewhere at `/home/gaspar/` which is empty at the start of each job, but it can be overridden by the `PIP_CACHE_DIR` environment variable. It is therefore suggested to create a directory like `/cvlabdata2/home/gaspar/pip_cache_dir` and add

```
ENV PIP_CACHE_DIR=/cvlabdata2/home/gaspar/pip_cache_dir
```
to your Dockerfile to set the variable. This line is not included in the tutorial Dockerfiles because it requires to user to create their directory. When using such an image, you can set the variable manually in your job definition by adding
```
export PIP_CACHE_DIR=/cvlabdata2/home/tyszkiew/pip_cache_dir
```
You can periodically clear the cache if it gets too full.


## Troubleshooting
If this guide is insufficient to solve your problem, ask around the lab and then contact `support-icit@epfl.ch` as they are the team supporting our compute infrastructure.