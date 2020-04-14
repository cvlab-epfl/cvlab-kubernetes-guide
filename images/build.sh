
docker build lab-base \
	--build-arg BASE_IMG=nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev \
	--network="host"

docker build lab-pytorch-apex \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev \
	--network="host"

# wget https://github.com/colmap/colmap/archive/3.6-dev.3.zip -O lab-colmap/colmap-3.6-dev.3.zip

docker build lab-colmap \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev \
	-t ic-registry.epfl.ch/cvlab/lis/lab-colmap:dev \
	--network="host"

docker push ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev
docker push ic-registry.epfl.ch/cvlab/lis/lab-colmap:dev

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:cuda10.1-pytorch1.4.0
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest 
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:cuda10.1-pytorch1.4.0
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest 
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10.1-pytorch1.4.0-tf2.1.0

