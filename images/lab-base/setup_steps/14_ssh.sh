#!/bin/bash

# To activate SSH, specify your public key in SSH_PUBLIC_KEY env variable in your pod config:
# env:
# - name: SSH_PUBLIC_KEY
#   value: "ssh-rsa A [...] HQ== someone@something"
# - name: SSH_PORT
#	value: "2500"


if [ -z "$SSH_PUBLIC_KEY" ]
then
	echo 'SSH not activated because $SSH_PUBLIC_KEY is not set'
else
	echo 'SSH activating'

	mkdir /var/run/sshd
	sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
	sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 
	sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config

	mkdir /home/$CLUSTER_USER/.ssh
	echo $SSH_PUBLIC_KEY > /home/$CLUSTER_USER/.ssh/authorized_keys

	chown -R $CLUSTER_USER /home/$CLUSTER_USER/.ssh
	chmod 700 /home/$CLUSTER_USER/.ssh
	chmod 600 /home/$CLUSTER_USER/.ssh/authorized_keys

	# start the SSH server
	if [ -z "$SSH_PORT" ]
	then
		sshd -D
	else
		sshd -D -p "$SSH_PORT"
	fi
fi 
