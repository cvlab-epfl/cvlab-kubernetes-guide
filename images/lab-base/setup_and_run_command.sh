#!/bin/bash 
# Run command specified in $1

/bin/bash /opt/lab/setup.sh

cd /home/$CLUSTER_USER
su $CLUSTER_USER -c "source /home/$CLUSTER_USER/.bashrc && $1"
