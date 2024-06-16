#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

cd $SCRIPT_DIR/files

if [ "$(docker ps -al | grep development-container-for-ros-2-on-m1-2-mac_for_${USER}_container)" ]; then
	echo "docker container restarting..."
	CONTAINER_ID=$(docker ps -a -f name=development-container-for-ros-2-on-m1-2-mac_for_${USER}_container --format "{{.ID}}")

	sudo rm -rf /tmp/.docker.xauth
	XAUTH=/tmp/.docker.xauth
	touch $XAUTH
	xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
	if [ ! -z "$xauth_list" ]; then
		echo $xauth_list | xauth -f $XAUTH nmerge -
	fi
	chmod a+r $XAUTH

	docker start $CONTAINER_ID
	echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	echo "_/ Plese access your container via RDP Client _/"
	echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
	exit
fi

nohup ./launch_container.sh xrdp >/tmp/nohup.out 2>&1 &

echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
echo "_/ Plese access localhost by RDP Client!! _/"
echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
