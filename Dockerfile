FROM jupyter/datascience-notebook:ubuntu-20.04

LABEL maintainer="Joshua L. Phillips <https://www.cs.mtsu.edu/~jphillips/>"
LABEL release-date="2020-10-09"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    curl \
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
    time \
    tmux \
    vim \
    wkhtmltopdf \
    xvfb \
    zip && \
    apt-get install -y \
    default-jre \
    dbus-x11 \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# CPU-only stack
# RUN mamba install --yes \
#     -c pytorch \
#     bash_kernel \
#     bokeh==2.3.3 \
#     dask-gateway \
#     dask-jobqueue \
#     dask-mpi \
#     expect \
#     gym \
#     jupyter-server-proxy \
#     nltk \
#     numpy==1.19.5 \
#     plotly \
#     pydot \
#     pytorch \
#     stanfordcorenlp \
#     tensorflow \
#     torchvision \
#     torchaudio \
#     websockify \
#     xvfbwrapper && \        
#     mamba clean --all -f -y && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# GPU-enabled stack
RUN mamba install --yes \
    bash_kernel \
    bokeh==2.3.3 \
    cudatoolkit==11.3.1 \
    cudnn==8.2.1.32 \
    dask-gateway \
    dask-jobqueue \
    dask-mpi \
    expect \
    gym \
    jupyter-server-proxy \
    nltk \
    numpy==1.19.5 \
    plotly \
    pydot \
    stanfordcorenlp \
    websockify \
    xvfbwrapper && \        
    mamba clean --all -f -y && \
    mamba install --yes \
    cudatoolkit-dev==11.3.1 && \
    pip install --quiet --no-cache-dir \
    gensim \
    tensorflow && \
    pip install --quiet --no-cache-dir \
    torch==1.8.2+cu111 \
    torchvision==0.9.2+cu111 \
    torchaudio==0.8.2 \
    -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Other root operations that can't (or maybe just shouldn't)
# be performed until the packages above are installed...
USER root

# Install:
# TurboVNC (for Desktop)
# VSCode (for IDE)
# NLTK Data (for nltk)
RUN wget 'https://sourceforge.net/projects/turbovnc/files/2.2.5/turbovnc_2.2.5_amd64.deb/download' -O turbovnc_2.2.5_amd64.deb && \
    apt-get install -y -q ./turbovnc_2.2.5_amd64.deb && \
    apt-get remove -y -q light-locker && \
    rm ./turbovnc_2.2.5_amd64.deb && \
    ln -s /opt/TurboVNC/bin/* /usr/local/bin/ && \
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=3.10.2 && \
    rm -rf "${HOME}/.cache" && \
    wget https://iweb.dl.sourceforge.net/project/circuit/2.7.x/2.7.1/logisim-generic-2.7.1.jar && \
    mkdir /opt/logisim && \
    mv logisim-generic-2.7.1.jar /opt/logisim/. && \
    python -c "import nltk; nltk.download('all','/usr/local/share/nltk_data')"

# Install Logisim
COPY logisim* /opt/logisim/
RUN ln -s /opt/logisim/logisim /usr/local/bin/. && \
    ln -s /opt/logisim/logisim.desktop /usr/share/applications/. && \
    ln -s /opt/logisim/mimeapps.list /usr/share/applications/.

# Configure extensions (seems unnecessary now)...
# RUN jupyter labextension install jupyterlab-plotly
# RUN python -m bash_kernel.install --sys-prefix

# Custom hook to setup home directory
RUN mkdir /usr/local/bin/before-notebook.d
COPY config-home.sh /usr/local/bin/before-notebook.d/.

# Switch back to user for final env
# configuration...
USER $NB_UID

# JS-Proxy package(s) configuration:
# jupyter-desktop-server (for Desktop)
# jupyter_codeserver_proxy (for IDE)
# ENV CODE_WORKINGDIR="${HOME}"
COPY ./dist/*.whl /${HOME}/
RUN pip install --quiet --no-cache-dir *.whl && \
    rm *.whl && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Configure user environment (gets copied from /home/jovyan
RUN cp /etc/skel/.bash_logout /etc/skel/.bashrc /etc/skel/.profile /home/${NB_USER}/. && conda init
