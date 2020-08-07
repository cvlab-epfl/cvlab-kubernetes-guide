
docker pull nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

docker build lab-base \
	--build-arg BASE_IMG=nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.2-devel \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.2-devel \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev \
	--network="host"

# docker build lab-pytorch-apex \
# 	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev \
# 	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev \
# 	--network="host"

docker build lab-pytorch-extra \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:dev \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev \
	--network="host"

wget https://github.com/colmap/colmap/archive/3.6.zip -O lab-colmap/colmap-3.6.zip

docker build lab-colmap \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-colmap:dev \
	--network="host"

docker push ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.2-devel
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:dev
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev
docker push ic-registry.epfl.ch/cvlab/lis/lab-colmap:dev


