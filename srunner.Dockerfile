FROM hangqiu/carla:0.9.13
LABEL authors="dunes"
ARG CARLA_VERSION=0.9.13
ARG PYTHON_VERSION=3.7

USER root

RUN apt-get update
RUN apt-get install -y git

USER carla

WORKDIR /home/carla
RUN git clone https://github.com/carla-simulator/scenario_runner.git

WORKDIR /home/carla/scenario_runner
RUN git checkout tags/v0.9.13
RUN python3 -m pip install --user -r requirements.txt
RUN python3 -m pip install numpy==1.23.5 # numpy.int is deprecated since version 1.24, remove if scenario_runner fixed this bug
