# deepole_challengeEval

Creates fieldmap from 2019 QSM Challenge data using custom tools. Evaluates DEEPOLE susceptibility map using the Stage 2 metrics of the challenge.

## Requirements
  - BNAC MBL in house toolbox (schweserbox)

## Description

1. Clone the repository into a directory `scripts/`
2. Download the challenge data and reconstructed maps from Zenodo (http://dx.doi.org/10.5281/zenodo.3998284) and save them in the directory `data/`.
3. Run `generate_fieldmap_custom.m` in Matlab. The field map and voxel-based reliability information will be written into the new directory `data/Sim2Snr2_custom`.
6. Run `EvaluationScript_4ChallengeParticipants.m` in Matlab to obtain the Stage 2 metrics. 



## Docker

To run the code in docker, you need a docker image with Matlab installed. Build the VNC-enabled container via Neurodocker by running the provided scripts:
```
./docker_01_createDockerfile.sh
./docker_02_buildImage.sh 
```
Start the docker container:
```
./docker_03_startContainer.sh PORT /full/path/to/this/repository
```
Here, `PORT` is the VNC port number you want to use and `/full/path/to/this/repository` is the full path of project directory that contains the `scripts/` and `data/` folders. Then connect to the VNC session with password `kjdfseYwh`. For example:
```
./docker_03_startContainer.sh 5902 /home/username/myproject
```
Start Matlab within the container and run the scripts mentioned above. No variable changes needed.
