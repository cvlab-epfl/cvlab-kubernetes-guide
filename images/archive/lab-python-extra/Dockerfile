# Additional programs to install on top of the main image
# start from the base image
FROM ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda10

# extra linux libraries
RUN apt-get update \
	&& apt-get install --no-install-recommends -y python3-dev build-essential  \
	&& apt-get clean

# extra python libraries
RUN pip --no-cache-dir install \
	cython \
	jinja2

# which need cython
RUN pip --no-cache-dir install \
	pycocotools gpustat

