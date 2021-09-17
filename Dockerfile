FROM jupyter/datascience-notebook:ubuntu-20.04

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"
LABEL release-date="2020-09-17"

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
    dask-gateway \
    dask-jobqueue \
    dask-mpi \
    expect \
    gym \
    nltk \
    numpy==1.19.5 \
    plotly \
    pydot \
    stanfordcorenlp \
    tensorflow \
    xvfbwrapper && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# PyTorch - Cuda 11.1 support
#    torch==1.8.2+cu111 \
#    torchvision==0.9.2+cu111 \
#    torchaudio==0.8.2 \
RUN pip install --quiet --no-cache-dir \
    torch==1.8.2+cpu \
    torchvision==0.9.2+cpu \
    torchaudio==0.8.2 \
    -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html && \
    pip install --quiet --no-cache-dir \
    gensim && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

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

# Custom hook to setup home directory
RUN mkdir /usr/local/bin/before-notebook.d
COPY config-home.sh /usr/local/bin/before-notebook.d/.

# Patch start.sh to link instead of copy.
# COPY start.sh.patch /usr/local/src/.
# RUN apt-get update && \
#     apt-get install -y \
#     patch && \
#     patch /usr/local/bin/start.sh /usr/local/src/start.sh.patch \
#     && apt-get clean

