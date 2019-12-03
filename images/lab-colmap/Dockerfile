# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

RUN apt update && apt-get install -y \
	cmake \
	libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libcgal-dev \
	libatlas-base-dev libsuitesparse-dev \
	libceres-dev \
	libglew-dev \
	qtbase5-dev libqt5opengl5-dev \
	unzip \
	&& apt-get clean

RUN mkdir /tmp/colmap-build
COPY colmap-dev.zip /tmp/colmap-build/colmap-dev.zip
RUN cd /tmp/colmap-build \
	&& unzip colmap-dev.zip \
	&& cd colmap-dev \
	&& mkdir build \
	&& cd build \
	&& cmake .. \
	&& make -j 6 \
	&& make install \
	&& cd / && rm -r /tmp/colmap-build
