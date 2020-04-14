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
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/colmap-build

# colmap source from https://github.com/colmap/colmap/archive/3.6-dev.3.zip
COPY colmap-3.6-dev.3.zip /tmp/colmap-build/colmap-dev.zip

# Build only cuda arch = 7.0 for our V100 GPU
# 	cmake: -DCUDA_ARCHS=7.0
# https://developer.nvidia.com/cuda-gpus

RUN cd /tmp/colmap-build \
	&& unzip colmap-dev.zip \
	&& mv colmap-3.6-dev.3 colmap-dev \
	&& cd colmap-dev \
	&& mkdir build \
	&& cd build \
	&& cmake .. -DCUDA_ARCHS=7.0 \
	&& make -j 12 \
	&& make install \
	&& cd / && rm -r /tmp/colmap-build
