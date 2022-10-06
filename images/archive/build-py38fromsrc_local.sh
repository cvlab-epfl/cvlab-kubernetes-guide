
VARIANT=cuda10
IMG_CUDA=nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04
docker pull $IMG_CUDA

docker build lab-base --file lab-base/Dockerfile_py38fromsrc \
	--build-arg BASE_IMG=$IMG_CUDA \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:$VARIANT \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:$VARIANT \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$VARIANT \
	--network="host"

docker build lab-pytorch-extra \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$VARIANT \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$VARIANT \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$VARIANT \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$VARIANT \
	--network="host"

docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$VARIANT
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$VARIANT
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$VARIANT
