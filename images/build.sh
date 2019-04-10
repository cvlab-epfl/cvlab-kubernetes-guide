 
docker build --build-arg BASE_IMG=ubuntu:cosmic -t ic-registry.epfl.ch/cvlab/lis/lab-base:cpu lab-base

docker build --build-arg BASE_IMG=nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04  -t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10 lab-base

docker build --build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10 -t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10 lab-python-ml
