#!/bin/bash 

# This script performs the setup and does nothing for the configured time (set it in pod config file, default 1h)
# You can enter the container and run commands in it
# 	kubectl exec -it pod_name -- /bin/bash
#	su your_user_name -c /bin/bash

/bin/bash /opt/lab/setup.sh

sleeper
