#!/bin/bash

echo "--- lab setup ---"

cd /opt/lab

for file in /opt/lab/setup_steps/*.sh
do
	echo "--- $file ---"
	$file
done

echo "--- lab setup complete ---"
