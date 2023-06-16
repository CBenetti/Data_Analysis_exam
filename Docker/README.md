# Docker informations

## Requirements
To build, first start from [rocker/r-ubuntu](https://hub.docker.com/r/rocker/r-ubuntu)

```bash
docker pull rocker/r-ubuntu:latest
```

## Building the docker

To obtain the project directory, a pull from GitHub is required, by doing

```bash
git clone CBenetti/Data_Analysis_exam
```

or

```bash
wget https://github.com/CBenetti/Data_Analysis_exam.git
```


To obtain all the used packages and build the docker, run

```bash
docker build Docker -t exam:v.01.00
```

from working directory, which should be the one at [Data_Analysis_exam repository](https://github.com/CBenetti/Data_Analysis_exam/).

After having built the docker image, it  can be run by

```bash
docker run -it -v ~/Data_Analysis_exam:/var/log/Data_Analysis_exam exam:v.01.00
```
with this command, the working directory is mounted to the folder. The path of the working directory depends on where the repository was pulled, and should be specified accordingly.


Alternatively, the image can be pulled from [Dockerhub](https://hub.docker.com/r/cbenetti/exam) by executing

```bash
docker pull cbenetti/exam:v.01.00
``` 

At this point, it can be run by executing

```bash
docker run -it -v ~/Data_Analysis_exam:/var/log/Data_Analysis_exam cbenetti/exam:v.01.00
```

as to run it and mount the working directory.
