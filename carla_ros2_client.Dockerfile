FROM ros:humble-ros-base-jammy
ARG CARLA_VERSION=0.9.15

# install ros package
RUN apt-get update && apt-get install -y \
      ros-${ROS_DISTRO}-rosbag2
# install carla PythonAPI PyPi package
RUN apt-get install python3-pip -y
RUN pip3 install carla==${CARLA_VERSION} pygame

RUN useradd -ms /bin/bash cisl \
&& usermod -aG sudo cisl \
&& echo "cisl:cisl" | chpasswd
  
USER cisl
WORKDIR /home/cisl