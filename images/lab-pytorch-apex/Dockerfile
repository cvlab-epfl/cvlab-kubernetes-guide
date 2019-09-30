# Install python and its packages

FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>


RUN mkdir /tmp/apex-build \
	&& cd /tmp/apex-build \
	&& wget --output-document=apex-master.zip https://github.com/NVIDIA/apex/archive/master.zip \
	&& 7z x apex-master.zip \
	&& cd apex-master \
	&& pip install --no-cache-dir --upgrade pip \
	&& pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . \
	&& cd / \
	&& rm -r /tmp/apex-build
