# Extra ML libs:
# * tensorflow
# * gluonCV  https://cv.gluon.ai/

ARG BASE_IMG
FROM ${BASE_IMG}

# GluonCV - repository of pretrained algorithms
#	gluon also install some other opencv, which fails to load (with missing lib libGL.so.1)
#	here we reinstate the right opencv package
RUN pip uninstall --yes opencv-contrib-python-headless \
	&& pip --no-cache-dir install mxnet-cu112 gluoncv \
	&& pip uninstall --yes opencv-python \
	&& pip --no-cache-dir install opencv-contrib-python-headless

ENV MXNET_HOME /cvlabsrc1/cvlab/pytorch_model_zoo/mxnet


# tensorflow
RUN pip --no-cache-dir install \
	tensorflow-gpu tensorflow_datasets tensorboard

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets
