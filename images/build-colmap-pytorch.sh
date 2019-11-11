
docker build lab-base \
	--build-arg BASE_IMG=geki/colmap:latest \
	-t ic-registry.epfl.ch/cvlab/lis/lab-base:colmap-cuda10

docker build lab-pytorch-cuda-ext \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-base:colmap-cuda10 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:colmap-cuda10

docker build lab-pytorch-apex \
	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-cuda-ext:colmap-cuda10 \
	-t ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:colmap-cuda10

docker push ic-registry.epfl.ch/cvlab/lis/lab-base:colmap-cuda10
docker push ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:colmap-cuda10

# docker build lab-python-ml \
# 	--build-arg BASE_IMG=ic-registry.epfl.ch/cvlab/lis/lab-pytorch-apex:latest \
# 	-t ic-registry.epfl.ch/cvlab/lis/lab-python-ml:latest