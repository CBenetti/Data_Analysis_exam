# Docker informations

## Requirements
To build, first start from [rocker/r-ubuntu](https://hub.docker.com/r/rocker/r-ubuntu)

```bash
docker pull rocker/r-ubuntu:latest"
```

## Building the docker

To obtain all the used packages and build the docker, run

```bash
docker build Docker -t examd:v.00.0
```

from working directory, which should be the one at [Data_Analysis_exam repository](https://github.com/CBenetti/Data_Analysis_exam/)


You have now obtained the docker image, which can be run by

```bash
docker run -it -v ~/Data_Analysis_exam:var/log/Data_Analysis_exam examd:v.00.0
```
with this command, the working directory is mounted to the folder. The path of the working directory depends on where the repository was pulled
