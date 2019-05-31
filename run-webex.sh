#!/bin/bash

set -e

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH

# Ensure xauth has been created for :0
if ! xauth list | grep -q "$(hostname --short)/unix:0"; then
    touch ~/.Xauthority
    xauth add ${DISPLAY} . $(mcookie)
fi

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run -it --rm \
        --name=webex \
        --volume=$XSOCK:$XSOCK:rw,Z \
        --volume=$XAUTH:$XAUTH:rw,Z \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY=$DISPLAY" \
        --user="webex" \
        --security-opt label=type:container_runtime_t \
        webex
