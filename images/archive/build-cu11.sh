
CUDA_IMG=nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04
BRANCH=cu113
docker pull $CUDA_IMG

docker build lab-base --file lab-base/Dockerfile \
	--build-arg BASE_IMG=$CUDA_IMG \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:$BRANCH \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:$BRANCH \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$BRANCH \
	--network="host"

docker build lab-pytorch-extra \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$BRANCH \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$BRANCH \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$BRANCH \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$BRANCH \
	--network="host"

docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:$BRANCH
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:$BRANCH
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$BRANCH
