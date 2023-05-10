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

from working directory 


You have now obtained the docker image, which can be run by

```bash
docker run -it examd:v.00.0
```
