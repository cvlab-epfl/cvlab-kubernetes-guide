
# Building your own images

## Setup

To build your own images, install docker on your computer:
```
sudo apt install docker.io
```
and login to our docker image repository:
```
docker login ic-registry.epfl.ch
```

Afterwards, clear the plain-text password file:
```
rm ~/.docker/config.json
```

<!-- wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-secretservice-v0.6.3-amd64.tar.gz -->
<!-- tar xvf docker-credential-secretservice-v0.6.3-amd64.tar.gz -->


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
There are also many publicly available images at the [Docker Hub](https://hub.docker.com/search?q=&type=image).

I prepared some images which will hopefully be of use to you (click to see Dockerfiles):

#### lab-base
[`ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel`](./lab-base/Dockerfile)  
`ic-registry.epfl.ch/cvlab/lis/lab-base:cpu` (same)

Basic utilities and the user-setup system.
You can make additional setup steps by putting a `.sh` script in `/opt/lab/setup_steps`. The setup steps are run in alphabetical order, hence the nubmers at the start.

#### lab-pytorch-cuda-ext
[`ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext`](./lab-pytorch-cuda-ext/Dockerfile)

* usual Python numeric libs
* Jupyter
* PyTorch and accessories
* OpenCV

#### lab-pytorch-apex

[`ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex`](./lab-pytorch-apex/Dockerfile)

Extra libs on top of PyTorch

- [APEX](https://github.com/NVIDIA/apex) - half precision
- [detectron2](https://github.com/facebookresearch/detectron2) - object detection


#### lab-python-ml

[`ic-registry.epfl.ch/cvlab/lis/lab-python-ml`](./lab-python-ml/Dockerfile)

Adds Tensorflow to the above.

#### lab-colmap

[`ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap`](./lab-colmap/Dockerfile)

Adds [COLMAP](https://github.com/colmap/colmap) multi-view 3d reconstruction.


If you need additional software installed, please let me know, or create your own image on top, as described below.

## Extending the image

In case you want to extend the image, please see this example [lab-python-extra Dockerfile](./lab-python-extra/Dockerfile).
Here we install libraries from the repositories, but it is possible to do much more.

```Dockerfile
# start from the base image
FROM ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10

# extra linux libraries
RUN apt-get update \
	&& apt-get install --no-install-recommends -y git \
	&& apt-get clean

# extra python libraries
RUN pip --no-cache-dir install \
	natsort jinja2 
```

Once your docker file is ready, build the image with [`docker build`](https://docs.docker.com/engine/reference/commandline/build/). Assuming it is in `lab-python-extra/Dockerfile`, the command is:
```
docker build lab-python-extra -t ic-registry.epfl.ch/cvlab/my_user_name/something:label_name
```

You can test the image locally, for example with:
```
docker run -it ic-registry.epfl.ch/cvlab/my_user_name/something:label_name /bin/bash
```
or using this provided [test environment](image-test-env/) if you are familiar with [`docker-compose`](https://docs.docker.com/compose/).

Once the image is built, we push it to the repository:
```
docker push ic-registry.epfl.ch/cvlab/my_user_name/something:label_name
```

Now you can use the image in your pods!

### Multi-stage builds

If your software needs to be compiled, you may benefit from [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/):
this involves creating a temporary container with the build tools where the compilation takes place, then we only copy the results of the compilation to the output image.
This saves space in the output image and allows the build process to be cached.


# Maintaining the images

To build the COLMAP image, download the source first - link and destination listed in `build.sh`.

The images are built by `build.sh`.

At this stage, they are in the `:dev` tag, and can be tested before being used by everyone.

Release using `publish.sh` which relabels from `:dev` to `:latest`.


### Server

The build is done on iccvlabsrv23, where I have the permission to launch docker.

On this server, the default docker network "bridge" does not give us access to the outside net.
This is fixed by `--network="host"`.

