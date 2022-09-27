#!/bin/bash

CLUSTER_USER=yourname # find this by running `id -un` on iccvlabsrv
CLUSTER_USER_ID=????? # find this by running `id -u` on iccvlabsrv
CLUSTER_GROUP_NAME=CVLAB-unit # find this by running `id -gn` on iccvlabsrv
CLUSTER_GROUP_ID=11166 # find this by running `id -g` on iccvlabsrv
MY_IMAGE="ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda11"
MY_WORK_DIR="/cvlabdata2/home/$CLUSTER_USER"


arg_job_name="$CLUSTER_USER-inter$1"
arg_cmd="timeout --preserve-status --kill-after=1m 8h jupyter lab --ip=0.0.0.0 --no-browser"

runai submit $arg_job_name \
	-i $MY_IMAGE \
	--interactive \
	--gpu 0.5 \
	--pvc runai-pv-cvlabdata1:/cvlabdata1 \
	--pvc runai-pv-cvlabdata2:/cvlabdata2 \
	--pvc runai-pv-cvlabsrc1:/cvlabsrc1 \
	--large-shm \
	-e CLUSTER_USER=$CLUSTER_USER \
	-e CLUSTER_USER_ID=$CLUSTER_USER_ID \
	-e CLUSTER_GROUP_NAME=$CLUSTER_GROUP_NAME \
	-e CLUSTER_GROUP_ID=$CLUSTER_GROUP_ID \
	-e TORCH_HOME="/cvlabsrc1/cvlab/pytorch_model_zoo" \
	--command -- /opt/lab/setup_and_run_command.sh "cd $MY_WORK_DIR && $arg_cmd"

sleep 1

runai describe job $arg_job_name

echo ""
echo "Connect - terminal:"
echo "	runai bash $arg_job_name"
echo "Connect - jupyter:"
echo "	kubectl port-forward $arg_job_name-0-0 8888:8888"

#  --pvc runai-pv-cvlabdata1:/cvlabdata1 \