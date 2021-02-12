FROM jupyter/datascience-notebook

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"

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
    xvfb \
    zip \
    && apt-get clean

USER $NB_UID
RUN cp /etc/skel/.bash_logout /etc/skel/.bashrc /etc/skel/.profile /home/${NB_USER}/. && conda init

RUN conda install --quiet --yes expect && \
    pip install --quiet --no-cache-dir \
    bash_kernel \
    gensim \
    gym \
    keras \
    nltk \
    plotly \
    pydot \
    'tensorflow==2.4.1' \
    torch \
    torchvision \
    xvfbwrapper \
    stanfordcorenlp && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


# Leave as root at the end for K8S to
# be able to provide sudo later on...
USER root
RUN python -c "import nltk; nltk.download('all','/usr/local/share/nltk_data')"
RUN jupyter labextension install jupyterlab-plotly
RUN python -m bash_kernel.install --sys-prefix

