# Install python and its packages

ARG BASE_IMG
FROM ${BASE_IMG}

# TF fails to find "libcudart.so.10.1"
# First, theres /usr/local/nvidia/lib64 in LD_LIBRARY_PATH, but /usr/local/nvidia does not exist
# We link the existing /usr/local/cuda-10.2 to fill that role.
# RUN ln -s /usr/local/cuda-10.2 /usr/local/nvidia \
# 	&& ln -s /usr/local/cuda-10.2/lib64/libcudart.so.10.2 /usr/local/nvidia/lib64/libcudart.so.10.1

# scientific
RUN pip --no-cache-dir install \
	numpy scipy scikit-image scikit-learn \
	matplotlib seaborn \
	pillow imageio h5py \
	einops \
	pandas \
	opencv-contrib-python-headless

RUN pip --no-cache-dir install \
	cython numba

# interactive
RUN pip --no-cache-dir install \
	ipython jupyterlab line-profiler \
	click tqdm \
	docopt \
	pyyaml easydict natsort \
	xonsh \
	gpustat \
	pycocotools \
	gdown wget \
	show-image

RUN python -c "import imageio; imageio.plugins.freeimage.download()"

# pytorch
# use shared cache for pytorch
ENV TORCH_MODEL_ZOO /cvlabsrc1/cvlab/pytorch_model_zoo/models
ENV TORCH_HOME /cvlabsrc1/cvlab/pytorch_model_zoo 
# install pytorch for cuda11

RUN pip --no-cache-dir install \
	torch torchvision torchaudio \
	--extra-index-url https://download.pytorch.org/whl/cu113 \
	&& pip --no-cache-dir install tensorboard \
	&& pip --no-cache-dir install --no-deps kornia 

# detectron2
RUN pip --no-cache-dir install \
	detectron2 \
	cityscapesScripts shapely \
	-f https://dl.fbaipublicfiles.com/detectron2/wheels/cu113/torch1.10/index.html

# pytorch3d
RUN pip --no-cache-dir install \
	pytorch3d \
	-f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1101/download.html
