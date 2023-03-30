#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE='focal_ws'

if [ ! "$(docker image ls -q ${NAME_IMAGE})" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "build" = $1 ]; then
			echo "Image ${NAME_IMAGE} does not exist."
			echo 'Now building image without proxy...'
			docker build --file=./noproxy.dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg SETLOCALE='JP'
			exit 0
		else
			echo "Docker image is not found. Please setup first!"
			exit 0
		fi
    elif [ ! $# -ne 2 ]; then
		if [ "build" = $1 ]; then
			if [ "US" = $2 ]; then
				echo "Image ${NAME_IMAGE} does not exist."
				echo 'Now building image without proxy...'
				docker build --file=./noproxy.dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg LOCALE='US'
				exit 0
			else
				echo "Image ${NAME_IMAGE} does not exist."
				echo 'Now building image without proxy...'
				docker build --file=./noproxy.dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg LOCALE='JP'
				exit 0
			fi
		else
			echo "Docker image is not found. Please setup first!"
			exit 0
		fi
    else
		echo "Docker image is not found. Please setup first!"
		exit 0
  	fi
fi

if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		docker commit focal_docker focal_ws:latest
		CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
		docker rm $CONTAINER_ID -f
		exit 0
	fi
fi

if [ ! $# -ne 1 ]; then
	if [ "stop" = $1 ]; then
		CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
		docker stop $CONTAINER_ID
		docker rm $CONTAINER_ID -f
		exit 0
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
DOCKER_NAME="focal_docker"
DOCKER_WORK_DIR="/home/${USER}"
MAC_WORK_DIR="/Users/${USER}"
DISPLAY=$(hostname):0

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
        --volume=/Users/${USER}:/home/${USER}/host_home:rw \
        --env=XAUTHORITY=${XAUTH} \
        --volume=${XAUTH}:${XAUTH} \
        --env=DISPLAY=${DISPLAY} \
		-it \
		--shm-size=4gb \
		--env=TERM=xterm-256color \
        -w ${DOCKER_WORK_DIR} \
        -u ${USER} \
        --hostname Docker-`hostname` \
        --add-host Docker-`hostname`:127.0.1.1 \
		-p 3389:3389 \
		-e PASSWD=${USER}"
		
		
## Allow X11 Connection
xhost +local:Docker-`hostname`
CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "xrdp" = $1 ]; then
		    echo "Remote Desktop Mode"
			docker run ${DOCKER_OPT} \
				--name=${DOCKER_NAME} \
				--entrypoint docker-entrypoint.sh \
				focal_ws:latest

			docker commit focal_docker focal_ws:latest
			CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
			docker stop $CONTAINER_ID
			docker rm $CONTAINER_ID -f
		else
			docker run ${DOCKER_OPT} \
				--name=${DOCKER_NAME} \
				--volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
				--entrypoint /bin/bash \
				focal_ws:latest
		fi
	else
		docker run ${DOCKER_OPT} \
			--name=${DOCKER_NAME} \
			--volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
			--entrypoint /bin/bash \
			focal_ws:latest
	fi
else
	if [ ! $# -ne 1 ]; then
		if [ "xrdp" = $1 ]; then
			docker commit focal_docker focal_ws:latest
			CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
			docker stop $CONTAINER_ID
			docker rm $CONTAINER_ID -f

		    echo "Remote Desktop Mode"
			docker run ${DOCKER_OPT} \
				--name=${DOCKER_NAME} \
				--volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
				--entrypoint docker-entrypoint.sh \
				focal_ws:latest

			docker commit focal_docker focal_ws:latest
			CONTAINER_ID=$(docker ps -a -f name=focal_docker --format "{{.ID}}")
			docker stop $CONTAINER_ID
			docker rm $CONTAINER_ID -f
		else
			docker start $CONTAINER_ID
			docker exec -it $CONTAINER_ID /bin/bash
		fi
	else
		docker start $CONTAINER_ID
		docker exec -it $CONTAINER_ID /bin/bash
	fi
fi

xhost -local:Docker-`hostname`

