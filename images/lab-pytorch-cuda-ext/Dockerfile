# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}

# TF fails to find "libcudart.so.10.1"
# First, theres /usr/local/nvidia/lib64 in LD_LIBRARY_PATH, but /usr/local/nvidia does not exist
# We link the existing /usr/local/cuda-10.2 to fill that role.
RUN ln -s /usr/local/cuda-10.2 /usr/local/nvidia \
	&& ln -s /usr/local/cuda-10.2/lib64/libcudart.so.10.2 /usr/local/nvidia/lib64/libcudart.so.10.1

# scientific
RUN pip --no-cache-dir install \
	numpy scipy scikit-image scikit-learn \
	matplotlib seaborn \
	pillow imageio h5py \
	einops \
	pandas \
	cython numba \
	opencv-contrib-python-headless

# interactive
RUN pip --no-cache-dir install \
	ipython jupyterlab line-profiler \
	click tqdm \
	docopt \
	pyyaml easydict natsort \
	xonsh \
	gpustat \
	pycocotools \
	gdown wget

RUN python -c "import imageio; imageio.plugins.freeimage.download()"

# pytorch
# use shared cache for pytorch
ENV TORCH_MODEL_ZOO /cvlabsrc1/cvlab/pytorch_model_zoo/models
ENV TORCH_HOME /cvlabsrc1/cvlab/pytorch_model_zoo 

RUN pip --no-cache-dir install \
	torch \
	torchvision \
	future tensorboard \
	&& pip --no-cache-dir install --no-deps kornia 
# future is for caffe2 / torch.tensorboard
# kornia has deps on old pytorch versions, so ignore its deps

