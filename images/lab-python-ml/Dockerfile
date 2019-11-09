# Install python and its packages

FROM  ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
MAINTAINER Krzysztof Lis <krzysztof.lis@epfl.ch>

# tensorflow
RUN pip --no-cache-dir install \
	tensorboard tensorflow-gpu
# lets tf find libcuda
# this is actually wrong and makes python fail to see the GPU
# libcuda is available on GPU servers, but not on the machine the images were tested on
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/compat
