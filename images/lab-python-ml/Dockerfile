# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
LABEL maintainer="Krzysztof Lis <krzysztof.lis@epfl.ch>"

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu

# GluonCV - repository of pretrained algorithms
RUN pip --no-cache-dir install \
	mxnet-cu102 gluoncv

ENV MXNET_HOME /cvlabsrc1/cvlab/pytorch_model_zoo/mxnet

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets
