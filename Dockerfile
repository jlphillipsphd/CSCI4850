FROM jupyter/datascience-notebook

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    vim \
    less \
    texlive-science \
    ssh \
    rsync

# CSCI 4350 & 4850
USER $NB_UID

RUN conda install --quiet --yes \
    keras \
    tensorflow \
    pytorch \
    torchvision \
    bash_kernel \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

