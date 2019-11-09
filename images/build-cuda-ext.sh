
docker build lab-base --build-arg BASE_IMG=nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04 -t ic-registry.epfl.ch/cvlab/lis/lab-base:cuda10.1-devel 
docker build lab-pytorch-cuda-ext -t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
docker build lab-pytorch-apex -t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
docker build lab-python-ml -t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest

docker tag ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10.1-pytorch1.3.0-tf2.0.0


