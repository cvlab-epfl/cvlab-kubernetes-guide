# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# python, hdf5, codecs for imageio
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		python3 python3-dev python3-pip \
		hdf5-tools h5utils \
		libgomp1 ninja-build \
	&& apt-get clean \
	&& ln -s /usr/bin/python3 /usr/local/bin/python \
	&& ln -s /usr/bin/pip3 /usr/local/bin/pip 

# core
RUN pip --no-cache-dir install --upgrade \
	setuptools wheel virtualenv pip

# scientific
RUN pip --no-cache-dir install \
	numpy scipy scikit-image scikit-learn \
	matplotlib seaborn \
	imageio h5py \
	einops \
	pandas \
	cython numba

# interactive
RUN pip --no-cache-dir install \
	ipython jupyterlab line-profiler \
	click tqdm \
	docopt \
	pyyaml easydict natsort \
	xonsh \
	gpustat \
	pycocotools

RUN python -c "import imageio; imageio.plugins.freeimage.download()"

# opencv
RUN pip --no-cache-dir install \
	opencv-contrib-python-headless

# pytorch
# use shared cache for pytorch
ENV TORCH_MODEL_ZOO /cvlabsrc1/cvlab/pytorch_model_zoo/models
ENV TORCH_HOME /cvlabsrc1/cvlab/pytorch_model_zoo 

RUN pip --no-cache-dir install \
	torch \
	torchvision \
	future tensorboard
# future is for caffe2 / torch.tensorboard

