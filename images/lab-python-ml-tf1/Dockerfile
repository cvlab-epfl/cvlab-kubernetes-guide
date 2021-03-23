
ARG BASE_IMG
FROM ${BASE_IMG}

RUN apt-get update \
	&& apt-get -y install libpcap-dev \
	&& ldconfig \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install \
	python-prctl \
	xmltodict pyyaml natsort ujson sklearn youtube-dl \
	pytest pytest-cov pytest-datafiles pylint coverage

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard==1.* tensorflow-gpu==1.*

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets

