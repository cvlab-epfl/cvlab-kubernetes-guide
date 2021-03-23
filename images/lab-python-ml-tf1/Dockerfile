
ARG BASE_IMG
FROM ${BASE_IMG}

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu==1.*

# stuff
RUN apt-get update \
	&& apt-get -y install ffmpeg libsm6 libxext-dev libxrender-dev libcap-dev \
	&& ldconfig \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install \
	xmltodict pyyaml natsort ujson sklearn youtube-dl \
	pytest pytest-cov pytest-datafiles pylint coverage

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets
