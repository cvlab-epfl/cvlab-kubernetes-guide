
ARG BASE_IMG
FROM ${BASE_IMG}
LABEL maintainer="Krzysztof Lis <krzysztof.lis@epfl.ch>"

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard==1 tensorflow-gpu==1

ENV TFDS_DATA_DIR /cvlabsrc1/cvlab/tensorflow_datasets
