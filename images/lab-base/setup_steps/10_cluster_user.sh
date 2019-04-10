#!/bin/bash 

echo "Setting up user ${CLUSTER_USER}"

if id -u $CLUSTER_USER > /dev/null 2>&1; then
	echo "User ${CLUSTER_USER} exists"
else
	echo "Creating user ${CLUSTER_USER}"

	groupadd --gid $CLUSTER_GROUP_ID $CLUSTER_GROUP_NAME
	useradd --no-user-group --uid $CLUSTER_USER_ID --gid $CLUSTER_GROUP_ID --shell /bin/bash --create-home $CLUSTER_USER
	echo "${CLUSTER_USER}:${CLUSTER_USER}" | chpasswd
	usermod -aG sudo,adm,root $CLUSTER_USER  
	echo "${CLUSTER_USER}   ALL = NOPASSWD: ALL" > /etc/sudoers

	touch /home/${CLUSTER_USER}/.bashrc

	echo "User setup done"
fi

