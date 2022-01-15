

CU_IMAGE=nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
BRANCH=cuda113

docker pull $CU_IMAGE

docker build lab-base --file lab-base/Dockerfile \
	--build-arg BASE_IMG=$CU_IMAGE \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:$BRANCH \
	--network="host"

docker build lab-pytorch \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:$BRANCH \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch:$BRANCH \
	--network="host"

docker build lab-python-ml \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch:$BRANCH \
	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$BRANCH \
	--network="host"


# docker run -it ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$BRANCH /bin/bash

#docker login ic-registry.epfl.ch

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch:$BRANCH
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:$BRANCH

#rm ~/.docker/config.json
