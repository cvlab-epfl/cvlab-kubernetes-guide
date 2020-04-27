

docker tag ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:dev ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
docker tag ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:dev ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
docker tag ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest
docker tag ic-registry.epfl.ch/cvlab/lis/lab-python-ml:dev ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10
docker tag ic-registry.epfl.ch/cvlab/lis/lab-colmap:dev ic-registry.epfl.ch/cvlab/lis/lab-colmap:latest

docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest
docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10
docker push ic-registry.epfl.ch/cvlab/lis/lab-colmap:latest

# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:cuda10.1-pytorch1.4.0
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:latest 
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest
# docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:cuda10.1-pytorch1.4.0
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest 
# docker push ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10.1-pytorch1.4.0-tf2.1.0
