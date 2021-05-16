# Extra ML libs:
# * tensorflow
# * gluonCV  https://cv.gluon.ai/

ARG BASE_IMG
FROM ${BASE_IMG}

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu tensorflow_datasets

# GluonCV - repository of pretrained algorithms
RUN pip --no-cache-dir install \
	mxnet-cu102 gluoncv

ENV MXNET_HOME /cvlabsrc1/cvlab/pytorch_model_zoo/mxnet
# So that mxnet can find libcuda located in CUDA_HOME/compat/libcuda.so.1
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/nvidia/compat"

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets
