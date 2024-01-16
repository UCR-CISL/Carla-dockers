FROM nvidia/vulkan:1.3-470
LABEL authors="dunes"
ARG CARLA_VERSION=0.9.13 ## <=0.9.13
ARG PYTHON_VERSION=3.7

RUN apt-key adv --fetch-keys "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub"

RUN packages='libsdl2-2.0 xserver-xorg libvulkan1 libomp5 software-properties-common' && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $packages --no-install-recommends

RUN apt-get update && \
    apt-get install -y sudo htop python${PYTHON_VERSION} python3-pip fontconfig

RUN useradd -ms /bin/bash carla \
    && usermod -aG sudo carla \
    && echo "carla:carla" | chpasswd

USER carla
WORKDIR /home/carla
ENV PATH="${PATH}:/home/carla/.local/bin"
RUN pip install --user pygame numpy \
    && pip3 install --user pygame numpy

RUN echo "carla" | sudo -S apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9
RUN echo "carla" | sudo -S add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla $(lsb_release -sc) main"
RUN echo "carla" | sudo -S apt-get update
RUN echo "carla" | sudo -S apt-get install -y carla-simulator=${CARLA_VERSION}

RUN echo "export CARLA_ROOT=/opt/carla-simulator" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla/dist/carla-${CARLA_VERSION}-py${PYTHON_VERSION}-linux-x86_64.egg" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla/agents" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI/carla" >> ~/.bashrc \
    && echo "export PYTHONPATH=\$PYTHONPATH:\${CARLA_ROOT}/PythonAPI" >> ~/.bashrc