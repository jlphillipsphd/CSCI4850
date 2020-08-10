FROM jupyter/datascience-notebook

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    g++ \
    gcc \
    gdb \
    graphviz \
    less \
    libtool \
    make \
    python-opengl \
    rsync \
    ssh \
    texlive-science \
    tmux \
    vim \
    xvfb \
    zip \
    && apt-get clean

# CSCI 4350 & 4850
USER $NB_UID

RUN pip install --quiet --no-cache-dir --use-feature=2020-resolver \
    bash_kernel \
    gensim \
    gym \
    keras \
    nltk \
    pydot \
    'tensorflow==2.2.0' \
    torch \
    torchvision \
    xvfbwrapper \
    stanfordcorenlp && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Leave as root at the end for K8S to
# be able to provide sudo later on...
USER root
RUN python -m nltk.downloader -d /usr/local/share/nltk_data all

