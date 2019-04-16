# Install python and its packages

FROM  ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# python and hdf5
RUN apt-get update \
	&& apt-get install --no-install-recommends -y python3 python3-pip \
		hdf5-tools h5utils \
		libgomp1 \ 
	&& apt-get clean \
	&& ln -s /usr/bin/python3 /usr/local/bin/python \
	&& ln -s /usr/bin/pip3 /usr/local/bin/pip 

# core
RUN pip --no-cache-dir install setuptools wheel virtualenv

# main
RUN pip --no-cache-dir install \
	click tqdm \
	numpy scipy scikit-image scikit-learn \
	matplotlib seaborn \
	imageio h5py \
	ipython jupyterlab

# opencv
RUN pip --no-cache-dir install \
	opencv-contrib-python-headless

# pytorch
# use shared cache for pytorch
ENV TORCH_MODEL_ZOO /cvlabsrc1/cvlab/pytorch_model_zoo 
RUN pip --no-cache-dir install \
	https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl \
	torchvision tensorboardX

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu
# lets tf find libcuda
# this is actually wrong and makes python fail to see the GPU
# libcuda is available on GPU servers, but not on the machine the images were tested on
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/compat
