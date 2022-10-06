
docker pull nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

docker build lab-base --file lab-base/Dockerfile_py38fromsrc \
	--build-arg BASE_IMG=nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:py38 \
	--network="host"

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:py38 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38-pytorch18 \
	--network="host"

# docker build lab-pytorch-extra \
# 	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38-pytorch18 \
# 	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src \
# 	--network="host"

# docker build lab-python-ml \
# 	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38-pytorch18 \
# 	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38-pytorch18-tf2 \
# 	--network="host"

docker build lab-python-ml-tf1 \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38-pytorch18 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38-pytorch18-tf1 \
	--network="host"

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:py38src
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-extra:py38src
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:py38src

docker push ic-registry.epfl.ch/cvlab/lab-pytorch-cuda-ext:py38-pytorch18