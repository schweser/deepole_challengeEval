#!/bin/bash

# Your personal docker image with Matlab installed:
MATLABDOCKERIMG="bnacmbl/private:matlab_r2018b_20181109_configured"

docker run repronim/neurodocker:0.7.0 generate docker \
--base=${MATLABDOCKERIMG} \
--pkg-manager=apt \
--fsl version=5.0.8 method=binaries \
--freesurfer version=6.0.0 method=binaries \
--ants version=2.0.0 method=binaries \
--convert3d version=1.0.0 method=binaries \
--vnc passwd=kjdfseYwh start_at_runtime=true geometry=1920x1080 \
--install xterm \
> Dockerfile
