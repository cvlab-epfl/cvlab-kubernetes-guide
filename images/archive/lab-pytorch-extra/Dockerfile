# Extra libs on top of PyTorch
# - APEX - half prefcision https://github.com/NVIDIA/apex
# - detectron2 - object detection https://github.com/facebookresearch/detectron2
# - PyTorch 3D - https://github.com/facebookresearch/pytorch3d

ARG BASE_IMG
FROM ${BASE_IMG}

# The libraries apex and detectron2 have Cuda pytorch extensions.
# We build on docker, without a GPU, so pytorch will not know which cuda level to use.
# We tell it to use Cuda level 7.0 for our V100 GPU
# https://developer.nvidia.com/cuda-gpus
ENV TORCH_CUDA_ARCH_LIST "7.0"

# detectron2 https://github.com/facebookresearch/detectron2
# uses libs: cityscapesScripts shapely
# 
# During the build, detectron check torch.cuda.is_available() to determine whether to build CUDA code.
# In our docker build, there is nvcc but there is no GPU.
# torch.cuda.is_available() reports false because of no GPU.
# Therefore, we force CUDA build through env  FORCE_CUDA="1"
# 	detectron2/setup.py:58
# We also need to set the cuda level, otherwise it would crash because it would not know which level to use.
ENV FORCE_CUDA "1"
RUN pip --no-cache-dir install \
	'git+https://github.com/facebookresearch/detectron2.git' \
	cityscapesScripts shapely

# PyTorch 3D https://github.com/facebookresearch/pytorch3d
#	https://github.com/facebookresearch/pytorch3d/blob/master/INSTALL.md
#	NvidiaCUB is used in Pytorch3D build 
ENV NVIDIACUB_VERSION="1.12.0"
RUN mkdir /usr/lib/nvidiacub && cd /usr/lib/nvidiacub \
	&& wget "https://github.com/NVIDIA/cub/archive/refs/tags/1.12.0.tar.gz" -O nvidiacub.tar.gz \
	&& tar --strip-components=1 -xf nvidiacub.tar.gz \
	&& rm nvidiacub.tar.gz
ENV CUB_HOME="/usr/lib/nvidiacub"

RUN pip --no-cache-dir install \
	'git+https://github.com/facebookresearch/pytorch3d.git'
