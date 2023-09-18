#!/bin/bash

SHELL_DIR=$(cd $(dirname $0) && pwd)

cd $SHELL_DIR/scripts

if [ "$(docker ps -al | grep jammy_kde_docker)" ]; then
	echo "docker container restarting..."
	CONTAINER_ID=$(docker ps -a -f name=jammy_kde_docker --format "{{.ID}}")
	
	sudo rm -rf /tmp/.docker.xauth
	XAUTH=/tmp/.docker.xauth
	touch $XAUTH
	xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
	if [ ! -z "$xauth_list" ]; then
		echo $xauth_list | xauth -f $XAUTH nmerge -
	fi
	chmod a+r $XAUTH

	docker start $CONTAINER_ID
	exit
fi

nohup ./launch_container.sh xrdp > /tmp/nohup.out &
