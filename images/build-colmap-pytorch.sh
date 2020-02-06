
docker build lab-colmap \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:latest

docker tag ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:latest ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:cuda10.1-pytorch1.4.0-colmap3.6.dev3

docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:cuda10.1-pytorch1.4.0-colmap3.6.dev3
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:latest 
