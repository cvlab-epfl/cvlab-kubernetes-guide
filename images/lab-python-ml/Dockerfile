# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
LABEL maintainer="Krzysztof Lis <krzysztof.lis@epfl.ch>"

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu

# TF fails to find libcudart in the usual location
# we symlink it so that it is on the LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda-10.2 /usr/local/nvidia \
	ln -s /usr/local/cuda-10.2/lib64/libcudart.so.10.2 /usr/local/nvidia/lib64/libcudart.so.10.1 \
	ldconfig

# GluonCV - repository of pretrained algorithms
RUN pip --no-cache-dir install \
	mxnet-cu102 gluoncv

ENV MXNET_HOME /cvlabsrc1/cvlab/pytorch_model_zoo/mxnet
