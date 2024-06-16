#!/bin/sh
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
cd $SCRIPT_DIR

NAME_IMAGE="development-container-for-ros-2-on-m1-2-mac_for_${USER}"

if [ ! "$(docker image ls -q ${NAME_IMAGE})" ]; then
    if [ ! $# -ne 1 ]; then
        if [ "build" = $1 ]; then
            echo "Image ${NAME_IMAGE} does not exist."
            echo 'Now building image without proxy...'
            docker build --file=./Dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg SETLOCALE='JP'
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
                docker build --file=./Dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg LOCALE='US'
                exit 0
            else
                echo "Image ${NAME_IMAGE} does not exist."
                echo 'Now building image without proxy...'
                docker build --file=./Dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -u) --build-arg UNAME=$USER --build-arg LOCALE='JP'
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
else
    if [ ! $# -ne 1 ]; then
        if [ "build" = $1 ]; then
            echo "Docker image is found. Please select mode!"
            exit 0
        fi
    elif [ ! $# -ne 2 ]; then
        if [ "build" = $1 ]; then
            echo "Docker image is found. Please select mode!"
            exit 0
        fi
    fi
fi

# Commit
if [ ! $# -ne 1 ]; then
    if [ "commit" = $1 ]; then
        docker commit development-container-for-ros-2-on-m1-2-mac_for_${USER}_container development-container-for-ros-2-on-m1-2-mac_for_${USER}:latest
        CONTAINER_ID=$(docker ps -a -f name=development-container-for-ros-2-on-m1-2-mac_for_${USER}_container --format "{{.ID}}")
        docker rm $CONTAINER_ID -f
        exit 0
    fi
fi

# Stop
if [ ! $# -ne 1 ]; then
    if [ "stop" = $1 ]; then
        CONTAINER_ID=$(docker ps -a -f name=development-container-for-ros-2-on-m1-2-mac_for_${USER}_container --format "{{.ID}}")
        docker stop $CONTAINER_ID
        docker rm $CONTAINER_ID -f
        exit 0
    fi
fi

# Delete
if [ ! $# -ne 1 ]; then
    if [ "delete" = $1 ]; then
        echo 'Now deleting docker container...'
        CONTAINER_ID=$(docker ps -a -f name=development-container-for-ros-2-on-m1-2-mac_for_${USER}_container --format "{{.ID}}")
        docker stop $CONTAINER_ID
        docker rm $CONTAINER_ID -f
        docker image rm development-container-for-ros-2-on-m1-2-mac_for_${USER}
        exit 0
    fi
fi

DOCKER_OPT=""
DOCKER_NAME="development-container-for-ros-2-on-m1-2-mac_for_${USER}_container"
DOCKER_WORK_DIR="/home/${USER}"
MAC_WORK_DIR="/Users/${USER}"

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
                --volume=/Users/${USER}:/home/${USER}/host_home:rw \
                --shm-size=4gb \
                --env=TERM=xterm-256color \
                -w ${DOCKER_WORK_DIR} \
                -u ${USER} \
                --ipc=host \
                --hostname Docker-$(hostname) \
                --add-host Docker-$(hostname):127.0.1.1 \
                -p 3389:3389 \
                -e PASSWD=${USER}"

## Allow X11 Connection
CONTAINER_ID=$(docker ps -a -f name=development-container-for-ros-2-on-m1-2-mac_for_${USER}_container --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
    if [ ! $# -ne 1 ]; then
        if [ "xrdp" = $1 ]; then
            echo "Remote Desktop Mode"
            docker run ${DOCKER_OPT} \
                --name=${DOCKER_NAME} \
                --entrypoint docker-entrypoint.sh \
                development-container-for-ros-2-on-m1-2-mac_for_${USER}:latest
        else
            docker run ${DOCKER_OPT} \
                --name=${DOCKER_NAME} \
                --volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
                -it \
                --entrypoint /bin/bash \
                development-container-for-ros-2-on-m1-2-mac_for_${USER}:latest
        fi
    else
        docker run ${DOCKER_OPT} \
            --name=${DOCKER_NAME} \
            --volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
            -it \
            --entrypoint /bin/bash \
            development-container-for-ros-2-on-m1-2-mac_for_${USER}:latest
    fi
else
    if [ ! $# -ne 1 ]; then
        if [ "xrdp" = $1 ]; then
            echo "Remote Desktop Mode"
            docker run ${DOCKER_OPT} \
                --name=${DOCKER_NAME} \
                --volume=$MAC_WORK_DIR/.Xauthority:$DOCKER_WORK_DIR/.Xauthority:rw \
                --entrypoint docker-entrypoint.sh \
                development-container-for-ros-2-on-m1-2-mac_for_${USER}:latest
        else
            docker start $CONTAINER_ID
            docker exec -it $CONTAINER_ID /bin/bash
        fi
    else
        docker start $CONTAINER_ID
        docker exec -it $CONTAINER_ID /bin/bash
    fi
fi
