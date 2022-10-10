#!/bin/bash
# Usage
# bash runai_one.sh job_name num_gpu "command"
# Examples:
#	`bash runai_one.sh name-hello-1 1 "python hello.py"`
#	- creates a job names `name-hello-1`
#	- uses 1 GPU
#	- enters MY_WORK_DIR directory (set below) and runs `python hello.py`
#
#	`bash runai_one.sh name-hello-2 0.5 "python hello_half.py"`
#	- creates a job names `name-hello-2`
#	- receives half of a GPUs memory, 2 such jobs can fit on one GPU!
#	- enters MY_WORK_DIR directory (set below) and runs `python hello_half.py`

arg_job_name=$1
arg_gpu=$2
# remove newlines from cmd
arg_cmd=`echo $3 | tr '\n' ' '`

CLUSTER_USER=yourname # find this by running `id -un` on iccvlabsrv
CLUSTER_USER_ID=????? # find this by running `id -u` on iccvlabsrv
CLUSTER_GROUP_NAME=CVLAB-unit # find this by running `id -gn` on iccvlabsrv
CLUSTER_GROUP_ID=11166 # find this by running `id -g` on iccvlabsrv

MY_IMAGE="ic-registry.epfl.ch/cvlab/lis/lab-python-ml:cuda11"
MY_WORK_DIR="/cvlabdata2/home/$CLUSTER_USER"

echo "Job [$arg_job_name] gpu $arg_gpu -> [$arg_cmd]"

runai submit $arg_job_name \
	-i $MY_IMAGE \
	--gpu $arg_gpu \
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

