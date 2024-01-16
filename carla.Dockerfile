FROM nvidia/vulkan:1.3-470
LABEL authors="dunes"
ARG CARLA_VERSION=0.9.15
ARG PYTHON_VERSION=3.7

RUN apt-key adv --fetch-keys "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub"

RUN packages='libsdl2-2.0 xserver-xorg libvulkan1 libomp5 software-properties-common' && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $packages --no-install-recommends

# python 3.7
RUN add-apt-repository ppa:deadsnakes/ppa


RUN apt-get update && \
    apt-get install -y sudo htop python${PYTHON_VERSION} python${PYTHON_VERSION}-distutils python3-pip fontconfig libjpeg8 libtiff5

RUN useradd -ms /bin/bash carla \
    && usermod -aG sudo carla \
    && echo "carla:carla" | chpasswd

USER carla
WORKDIR /home/carla
ENV PATH="${PATH}:/home/carla/.local/bin"
RUN python${PYTHON_VERSION} -m pip install --upgrade pip
RUN python${PYTHON_VERSION} -m pip install --user pygame numpy

# Carla Server
RUN wget https://carla-releases.s3.us-east-005.backblazeb2.com/Linux/CARLA_${CARLA_VERSION}.tar.gz
RUN mkdir CARLA_${CARLA_VERSION}
RUN tar -xvzf CARLA_${CARLA_VERSION}.tar.gz -C CARLA_${CARLA_VERSION}
RUN rm -rf CARLA_${CARLA_VERSION}.tar.gz

WORKDIR /home/carla/CARLA_${CARLA_VERSION}

# Additional maps
#RUN wget https://carla-releases.s3.us-east-005.backblazeb2.com/Linux/AdditionalMaps_${CARLA_VERSION}.tar.gz
#RUN mv AdditionalMaps_${CARLA_VERSION}.tar.gz ./Import/
#RUN ./ImportAssets.sh
#RUN rm -rf ./Import/AdditionalMaps_${CARLA_VERSION}.tar.gz

# Config path
RUN echo "export CARLA_ROOT=/home/carla/CARLA_${CARLA_VERSION}" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla/dist/carla-${CARLA_VERSION}-py${PYTHON_VERSION}-linux-x86_64.egg" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla/agents" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI" >> ~/.bashrc
