# define an argument which can be specified at build time. This means that we can
# re-use this Dockerfile for different base images as new CUDA versions are released.
ARG BASE_IMG

# use the base image as the starting point
FROM ${BASE_IMG}

# this is optional
LABEL maintainer="Krzysztof Lis <krzysztof.lis@epfl.ch>"

# set the timezone to Zurich, not having this set causes some problems with other software
ENV TZ=Europe/Zurich
# aside from creating an environment variable, we also need to create a symlink
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# this line executes multiple commands in a single RUN instruction
# to reduce the number of layers in the final image. The commands are chained with &&.
# The first command replaces the default ubuntu mirror with the ETH mirror.
# The second command updates the package list and the third command installs the
# packages we need. The last command cleans up the apt cache to reduce the size of the image.
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

# update pip
RUN pip install --upgrade --no-cache-dir pip

# core python packages for build system
RUN pip --no-cache-dir install \
		setuptools \
	&& pip --no-cache-dir install --upgrade \
		wheel virtualenv

# create a location for the lab setup scripts
RUN mkdir /opt/lab
COPY setup.sh setup_and_run_command.sh /opt/lab/
COPY setup_steps /opt/lab/setup_steps

# make sure the setup scripts are executable
RUN chmod -R a+x /opt/lab/

# create a default command to run when the container is started, it can be overwritten
# by passing a command to the docker run command (the usual case)
CMD ["/opt/lab/setup_and_run_command.sh"]