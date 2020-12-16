#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE='bionic_ws'

if [ ! "$(docker image ls -q ${NAME_IMAGE})" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "setup" = $1 ]; then
			echo "Image ${NAME_IMAGE} does not exist."
			echo 'Now building image without proxy...'
			docker build --file=./noproxy.dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER
		else
			echo "Docker image is not found. Please setup first!"
			exit 0
		fi
    else
		echo "Docker image is not found. Please setup first!"
		exit 0
  	fi
else
	if [ ! $# -ne 1 ]; then
		if [ "commit" = $1 ]; then
			docker commit bionic_docker bionic_ws:latest
			CONTAINER_ID=$(docker ps -a -f name=bionic_docker --format "{{.ID}}")
			docker rm $CONTAINER_ID
			exit 0
		else
		    echo "Docker image is found. Setup is already finished!"
		fi
	fi
fi

XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ];  then
  echo $xauth_list | xauth -f $XAUTH nmerge -
fi
chmod a+r $XAUTH

DOCKER_OPT=""
DOCKER_NAME="bionic_docker"
DOCKER_WORK_DIR="/home/${USER}"
MAC_WORK_DIR="/Users/${USER}"
DISPLAY=$(hostname):0

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
        --env=XAUTHORITY=${XAUTH} \
        --volume=${XAUTH}:${XAUTH} \
        --env=DISPLAY=${DISPLAY} \
        -w ${DOCKER_WORK_DIR} \
        -u ${USER} \
        --hostname Docker-`hostname` \
        --add-host Docker-`hostname`:127.0.1.1 \
		-p 3389:3389 \
		-e PASSWD=${USER}"
		
		
## Allow X11 Connection
xhost +local:`hostname`-Docker
CONTAINER_ID=$(docker ps -a -f name=bionic_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "xrdp" = $1 ]; then
		    echo "Remote Desktop Mode"
			docker run ${DOCKER_OPT} \
				-it \
				--shm-size=1gb \
				--name=${DOCKER_NAME} \
				bionic_ws:latest \
				bash -c docker-entrypoint.sh
		else
			docker run ${DOCKER_OPT} \
				-it \
				--volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
				--shm-size=1gb \
				--env=TERM=xterm-256color \
				--net=host \
				--name=${DOCKER_NAME} \
				bionic_ws:latest \
				bash
		fi
	else
		docker run ${DOCKER_OPT} \
			-it \
			--volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
			--shm-size=1gb \
			--env=TERM=xterm-256color \
			--net=host \
			--name=${DOCKER_NAME} \
			bionic_ws:latest \
			bash
	fi
else
	if [ ! $# -ne 1 ]; then
		if [ "xrdp" = $1 ]; then
			docker commit bionic_docker bionic_ws:latest
			CONTAINER_ID=$(docker ps -a -f name=bionic_docker --format "{{.ID}}")
			docker rm $CONTAINER_ID

		    echo "Remote Desktop Mode"
			docker run ${DOCKER_OPT} \
				-it \
				--shm-size=1gb \
				--name=${DOCKER_NAME} \
				bionic_ws:latest \
				bash -c docker-entrypoint.sh
		else
			docker start $CONTAINER_ID
			docker attach $CONTAINER_ID
		fi
	else
		docker start $CONTAINER_ID
		docker attach $CONTAINER_ID
	fi
fi

xhost -local:Docker-`hostname`

