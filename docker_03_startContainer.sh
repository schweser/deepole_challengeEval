#!/bin/bash

PORT=$1
PROJECTDIR=$2

LICENSEDIR=~/git/licenses/matlab
MATLABVERSION=R2018a
LICENSEHOSTID=E4:CE:8F:60:8F:0A


docker run \
        -d --rm -it \
        --mac-address="${LICENSEHOSTID}" \
        -v ${LICENSEDIR}/${MATLABVERSION}:/usr/local/MATLAB/${MATLABVERSION}/licenses/:ro \
        -v ${PROJECTDIR}:/research/:rw \
        -p ${PORT}:5901 \
        matlab_vnc xterm




