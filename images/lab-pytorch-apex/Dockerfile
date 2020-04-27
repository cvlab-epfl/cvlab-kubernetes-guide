# Extra libs on top of PyTorch
# - APEX - half prefcision https://github.com/NVIDIA/apex
# - detectron2 - object detection https://github.com/facebookresearch/detectron2


ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# detectron2 https://github.com/facebookresearch/detectron2
# uses libs: cityscapesScripts shapely
# 
# During the build, detectron check torch.cuda.is_available() to determine whether to build CUDA code.
# In our docker build, there is nvcc but there is no GPU.
# torch.cuda.is_available() reports false because of no GPU.
# Therefore, we force CUDA build through env  FORCE_CUDA="1"
# 	detectron2/setup.py:58
ENV FORCE_CUDA "1"
RUN pip --no-cache-dir install \
	'git+https://github.com/facebookresearch/detectron2.git' \
	cityscapesScripts shapely

# APEX https://github.com/NVIDIA/apex
#
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
