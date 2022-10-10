
CUDA_IMG=nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
docker pull $CUDA_IMG

docker build lab-base --file lab-base/Dockerfile_py38fromsrc \
	--build-arg BASE_IMG=$CUDA_IMG \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:py38src \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:py38src \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38src \
	--network="host"

docker build lab-pytorch-extra \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38src \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38src \
	--network="host"

docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38src
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38src
