
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

## Dockerfiles

An image is specified by a directory containing a file named *Dockerfile*.
Here is the [Dockerfile documentation](https://docs.docker.com/engine/reference/builder/).

At the beginning, we say on top of which file we build:
```
FROM base_image_tag
```

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

Check these example Dockerfiles for my images:

#### lab-base
[`ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10`](./lab-base/Dockerfile)  
`ic-registry.epfl.ch/cvlab/lis/lab-base:cpu` (same)

Basic utilities and the user-setup system.
You can make additional setup steps by putting a `.sh` script in `/opt/lab/setup_steps`. The setup steps are run in alphabetical order, hence the nubmers at the start.

#### lab-python-ml

[`ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10`](./lab-python-ml/Dockerfile)

Python 3.6 + PIP, common Python libraries, Jupyter, OpenCV, Pytorch, Tensorflow.

If you need additional software installed, please let me know, or create your own image on top, as described below.

## Extending the image

In case you want to extend the image, please see this example [lab-python-extra Dockerfile](./lab-python-extra/Dockerfile).

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

Once your docker file is ready, build the image. Assuming it is in `lab-python-extra/Dockerfile`, the command is:
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

#### Multi-step builds



<!-- # docker build -t ic-registry.epfl.ch/cvlab/lis/lab-python-extra:cuda10 lab-python-extra

# docker built -t TAG_NAME DIRECTORY_WITH_DOCKERFILE
# docker build -t ic-registry.epfl.ch/cvlab/lis/lab-python-extra:cuda10 .

# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-extra:cuda10 -->

