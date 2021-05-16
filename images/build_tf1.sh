
docker pull nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

docker build lab-base \
	--build-arg BASE_IMG=nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:py36 \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:py36 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py36 \
	--network="host"

docker build lab-python-ml-tf1 \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py36 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py36-tf1 \
	--network="host"

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38src
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38src

docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py36-tf1
