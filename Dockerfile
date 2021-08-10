FROM jupyter/datascience-notebook:ubuntu-20.04

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"
LABEL release-date="2020-08-10"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    emacs-nox \
    enscript \
    g++ \
    gcc \
    gdb \
    graphviz \
    less \
    libtool \
    make \
    poppler-utils \
    python-opengl \
    rsync \
    ssh \
    texlive-science \
    tmux \
    vim \
    wkhtmltopdf \
    xvfb \
    zip \
    && apt-get clean

USER $NB_UID

RUN mamba install --quiet --yes \
    bash_kernel \
    expect \
    gensim \
    gym \
    nltk \
    plotly \
    pydot \
    pytorch \
    stanfordcorenlp \
    tensorflow \
    torchvision \
    xvfbwrapper && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Just keeping this around if needed later...
#    pip install --quiet --no-cache-dir \

# This will be ignored on k8s, docker-compose, etc. since the
# volume mounted at /home/jovyan will not have them, but
# it's useful for stand-alone containers.
RUN cp /etc/skel/.bash_logout /etc/skel/.bashrc /etc/skel/.profile /home/${NB_USER}/. && conda init

# Leave as root at the end for K8S to
# be able to provide sudo later on...
USER root
RUN python -c "import nltk; nltk.download('all','/usr/local/share/nltk_data')"
# RUN jupyter labextension install jupyterlab-plotly
# RUN python -m bash_kernel.install --sys-prefix

