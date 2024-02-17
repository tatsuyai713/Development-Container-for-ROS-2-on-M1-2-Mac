#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
cd $SCRIPT_DIR
pwd
cd ./files

NAME_IMAGE='development-container-for-ros-2-on-m1-2-mac_for_${USER}'

if [ $# -ne 1 ]; then
	echo "Please select keyboard type. (JP or US)"
	exit
fi
REGION=$1

if [ "$(docker image ls -q ${NAME_IMAGE})" ]; then
	echo "Docker image is already built!"
	exit
fi

echo "Build Container"

if [ "US" = $REGION ]; then
	./launch_container.sh build US
elif [ "JP" = $REGION ]; then
	./launch_container.sh build JP
else
	echo "Please select keyboard type. (JP or US)"
	exit
fi


echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
echo "_/Building container image is finished!!_/"
echo "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
