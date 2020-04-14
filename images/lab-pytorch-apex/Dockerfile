# Extra libs on top of PyTorch
# - APEX - half prefcision https://github.com/NVIDIA/apex
# - detectron2 - object detection https://github.com/facebookresearch/detectron2


ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# detectron uses: cityscapesScripts shapely

RUN pip --no-cache-dir install \
	'git+https://github.com/facebookresearch/detectron2.git' \
	cityscapesScripts shapely

# Build apex for 7.0 cuda level for our V100 GPU
# Default is 6.0 6.1 6.2 7.0 7.5
# https://developer.nvidia.com/cuda-gpus
ENV TORCH_CUDA_ARCH_LIST "7.0"
RUN mkdir /tmp/apex-build \
	&& cd /tmp/apex-build \
	&& wget --output-document=apex-master.zip https://github.com/NVIDIA/apex/archive/master.zip \
	&& 7z x apex-master.zip \
	&& cd apex-master \
	&& pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . \
	&& cd / \
	&& rm -r /tmp/apex-build
