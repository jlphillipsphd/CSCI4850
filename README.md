# CSCI4850
Docker container for CSCI 4850/5850 - Neural Networks (ver. 2022-08-11)

This container is built on top of jupyter/datascience-notebook provided by jupyter/docker-stacks. It provides a JupyterLab environment with several essential (and non-essential) tools used in CSCI4850/5850 - Neural Networks.

The recommended way to obtain the docker image is to pull from DockerHub:
```
docker pull jlphillips/csci4850
docker run -it --rm -p 8888:8888 --user root -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work jlphillips/csci4850
```

**You will need to modify `/home/jphillips` to instead indicate where your files are located in order to make this work...**

There is an alternative way to run the image for use with NVIDIA GPUs as well with the following:
```
docker pull jlphillips/csci4850
docker run -it --rm -p 8888:8888 --user root --gpus all -e NVIDIA_VISIBLE_DEVICES=all -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work jlphillips/csci4850
```

You will also need to make sure your Docker installation is set up to use the Nvidia container toolkit, as described [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html), or just `sudo apt-get install nvidia-container-toolkit` if you happen to be using the Lambda Stack on your host.

If you want to build the image yourself (rather than pulling the image from DockerHub - note this is probably not what you want to do), you may do the following...

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

You may also use the image with NVIDIA GPUs as well with the following (given the container toolkit was installed as described above):
```
docker run -it --rm -p 8888:8888 --user root --gpus all -e NVIDIA_VISIBLE_DEVICES=all -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes -v /home/jphillips:/home/jovyan/work csci4850
```

