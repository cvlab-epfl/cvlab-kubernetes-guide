# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}
# FROM  ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

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
	kornia \
	future tensorboard
# future is for caffe2 / torch.tensorboard

