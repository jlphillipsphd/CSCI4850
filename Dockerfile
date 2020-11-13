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

# Lambda Stack - easy container config
# WORKDIR /root/

# Add libcuda dummy dependency
#ADD control .
#RUN apt-get update && \
#	DEBIAN_FRONTEND=noninteractive apt-get install --yes equivs && \
#	equivs-build control && \
#	dpkg -i libcuda1-dummy_10.2_all.deb && \
#	rm control libcuda1-dummy_10.2_all.deb && \
#	apt-get remove --yes --purge --autoremove equivs && \
#	rm -rf /var/lib/apt/lists/*

# Setup Lambda repository
ADD lambda.gpg /root/lambda.gpg
RUN apt-get update && \
	apt-get install --yes gnupg && \
	apt-key add /root/lambda.gpg && \
	rm lambda.gpg && \
	echo "deb http://archive.lambdalabs.com/ubuntu focal main" > /etc/apt/sources.list.d/lambda.list && \
	echo "Package: *" > /etc/apt/preferences.d/lambda && \
	echo "Pin: origin archive.lambdalabs.com" >> /etc/apt/preferences.d/lambda && \
	echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/lambda && \
	echo "cudnn cudnn/license_preseed select ACCEPT" | debconf-set-selections && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get install \
		--yes \
		--no-install-recommends \
		--option "Acquire::http::No-Cache=true" \
		--option "Acquire::http::Pipeline-Depth=0" \
		nvidia-cuda-toolkit && \
		# lambda-stack-cuda \
		# lambda-server && \
	rm -rf /var/lib/apt/lists/*

# Setup for nvidia-docker
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2"

# CSCI 4350 & 4850
USER $NB_UID

RUN pip install --quiet --no-cache-dir --use-feature=2020-resolver \
    bash_kernel \
    gensim \
    gym \
    keras \
    nltk \
    plotly \
    pydot \
    'tensorflow==2.3.1' \
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

