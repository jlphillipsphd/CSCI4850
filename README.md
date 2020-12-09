# CSCI4850
Docker container for CSCI 4850/5850 - Neural Networks (ver. 2020-12-09)

This container is built on top of jupyter/datascience-notebook provided by jupyter/docker-stacks. It provides a JupyterLab environment with several essential (and non-essential) tools used in CSCI4850/5850 - Neural Networks.

The recommended way to obtain the docker image is to pull from DockerHub:
```
docker pull jlphillips/csci4850
docker run -it --rm -p 8888:8888 --user root -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work jlphillips/csci4850
```

**You will need to modify `/home/jphillips` to instead indicate where your files are located in order to make this work...**

There is an alternative image for use with NVIDIA GPUs via Lambda Stack as well (**significantly larger image** ~ 20GB) with the following:
```
docker pull jlphillips/csci4850:lambda
docker run -it --rm -p 8888:8888 --user root -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work jlphillips/csci4850:lambda
```

However, if you want to build the image yourself, then do the following...

To prep:
```
git clone https://github.com/jlphillipsphd/CSCI4850.git
```
 
To build:
```
docker build -t csci4850 CSCI4850
```

To run:
```
docker run -it --rm -p 8888:8888 --user root -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work csci4850
```

You may instead build the image for use with NVIDIA GPUs via Lambda Stack as well (**significantly larger image** ~ 20GB) with the following:
```
docker build -t csci4850 -f CSCI4830/Dockerfile.lambda CSCI4850
```

