
ARG BASE_IMG
FROM ${BASE_IMG}

MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# install linux packages
RUN sed 's@archive.ubuntu.com@ubuntu.ethz.ch@' -i /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get --no-install-recommends -y install \
		sudo htop tmux locate \
		mc less vim git fish \
		curl wget \
		p7zip-full \
		cmake \
	&& apt-get clean

RUN mkdir /opt/lab
COPY setup.sh setup_and_run_command.sh setup_and_wait.sh /opt/lab/
COPY setup_steps /opt/lab/setup_steps

ENV AUTO_SHUTDOWN_TIME 1h
CMD ["/opt/lab/setup_and_wait.sh"]
