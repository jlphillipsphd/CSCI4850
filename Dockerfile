FROM jupyter/datascience-notebook:7a0c7325e470

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    libtool \
    vim \
    less \
    texlive-science \
    ssh \
    rsync \
    zip \
    tmux \
    graphviz \
    xvfb \
    python-opengl \
    gdb

# CSCI 4350 & 4850
USER $NB_UID

RUN conda install --quiet --yes \
    keras \
    tensorflow \
    pytorch \
    torchvision \
    bash_kernel \
    pydot \
    xvfbwrapper \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install \
    gym \
    gensim \
    nltk \
    stanfordcorenlp

RUN python -m nltk.downloader all

