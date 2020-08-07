
ARG BASE_IMG
FROM ${BASE_IMG}

LABEL maintainer="Krzysztof Lis <krzysztof.lis@epfl.ch>"

# install linux packages + python
RUN sed 's@archive.ubuntu.com@ubuntu.ethz.ch@' -i /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get --no-install-recommends -y install \
		sudo htop tmux screen locate \
		mc less vim git fish \
		curl wget \
		p7zip-full \
		cmake \
		python3 python3-dev python3-pip \
		hdf5-tools h5utils \
		libgomp1 ninja-build \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& ln -s /usr/bin/python3 /usr/local/bin/python \
	&& ln -s /usr/bin/pip3 /usr/local/bin/pip 

# core
# + tools for sleeper
RUN pip --no-cache-dir install \
		setuptools \
	&& pip --no-cache-dir install --upgrade \
		wheel virtualenv pip \
	&& pip --no-cache-dir install --upgrade \
		psutil py3nvml

RUN mkdir /opt/lab
COPY setup.sh setup_and_run_command.sh setup_and_wait.sh sleeper /opt/lab/
RUN ln -s /opt/lab/sleeper /usr/bin/sleeper
COPY setup_steps /opt/lab/setup_steps

# make sure the setup scripts are executable
RUN chmod -R a+x /opt/lab/

CMD ["/opt/lab/setup_and_wait.sh"]
