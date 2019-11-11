
docker build lab-colmap \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex-colmap:latest
