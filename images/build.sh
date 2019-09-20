 
# docker build lab-base --build-arg BASE_IMG=ubuntu:disco -t ic-registry.epfl.ch/cvlab/lis/lab-base:cpu 

docker build lab-base --build-arg BASE_IMG=nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 -t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10 

docker build lab-base --build-arg BASE_IMG=nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04 -t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10-devel 

docker build lab-python-ml -t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10
docker build lab-python-extra -t ic-registry.epfl.ch/cvlab/lis/lab-python-extra-example:cuda10

docker build lab-pytorch-cuda-ext -t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest


# docker push ic-registry.epfl.ch/cvlab/lis/lab-base:cpu 

docker push ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10

docker tag ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10  ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest

docker tag ic-registry.epfl.ch/cvlab/lis/lab-python-extra-example:cuda10  ic-registry.epfl.ch/cvlab/lis/lab-python-extra-example:latest
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-extra-example:cuda10
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-extra-example:latest
