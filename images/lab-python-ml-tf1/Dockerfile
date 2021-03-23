
ARG BASE_IMG
FROM ${BASE_IMG}

RUN pip --no-cache-dir install \
	xmltodict pyyaml natsort ujson sklearn \
	python-prctl youtube-dl \
	pillow imageio \
	pytest pytest-cov pytest-datafiles pylint coverage

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard==1.* tensorflow-gpu==1.*

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets

