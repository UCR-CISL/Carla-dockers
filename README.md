# Carla Dockers

## Carla Docker Image
- base image: nvidia/vulkan:1.3-470 (ubuntu 20.04, python 3.8)
- cuda 11.4
- carla 0.9.13

*Note:* If you want a different carla version, follow carla's [official instructions](https://github.com/carla-simulator/carla/blob/master/Util/Docker/README.md). Caution that as of Nov 2023, this link builds carla with ubuntu 18 so may not be compatible for other packages such as ROS2.


#### Prerequisites
Similar to carla official docker prerequisites
* Install docker following instructions [here](https://docs.docker.com/engine/install/)
* Install nvidia-docker2 following instructions [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installation-guide)

#### Getting the docker image
Build the docker locally
```commandline
sudo docker build -t hangqiu/carla:0.9.13 --file ./carla.Dockerfile .
```
Or, pull the image from docker hub
```commandline
sudo docker pull hangqiu/carla:0.9.13
```

#### Run carla simulator
Run the carla server
```commandline
sudo docker run --privileged --gpus all --net=host -e DISPLAY=$DISPLAY \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d \
    hangqiu/carla:0.9.13 \
    /bin/bash /opt/carla-simulator/CarlaUE4.sh
```
And run carla client with manual control
```commandline
sudo docker run -it --privileged --gpus all --net=host -e DISPLAY=$DISPLAY \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d \
    hangqiu/carla:0.9.13 \
    /bin/python3 /opt/carla-simulator/PythonAPI/examples/manual_control.py 
```

## Scenario Runner Docker Image

#### Getting the docker image

Build the docker locally. The scenario docker image is built on top of the carla image. [Get the carla image](#carla-docker-image) first before proceeding.
```commandline
sudo docker build -t hangqiu/srunner:0.9.13 --file ./srunner.Dockerfile .
```
Or, pull the image from docker hub
```commandline
sudo docker pull hangqiu/srunner:0.9.13
```

#### Run Scenario Runner 

Start the carla server
```commandline
sudo docker run --privileged --gpus all --net=host -e DISPLAY=$DISPLAY \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d \
    hangqiu/carla:0.9.13 \
    /bin/bash /opt/carla-simulator/CarlaUE4.sh
```
Run a scenario,
```commandline
sudo docker run -it --privileged --gpus all --net=host -e DISPLAY=$DISPLAY \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d  \
    hangqiu/srunner:0.9.13  \
    /bin/python3 scenario_runner.py --scenario FollowLeadingVehicle_1 --reloadWorld
```
This starts the scenario *FollowLeadingVehicle_1*. Check out [more scenarios](https://github.com/carla-simulator/scenario_runner/tree/master/srunner/scenarios) to run.

Now start a manual control agent
```commandline
sudo docker run -it --privileged --gpus all --net=host -e DISPLAY=$DISPLAY \
    -v /usr/share/vulkan/icd.d:/usr/share/vulkan/icd.d \
    hangqiu/srunner:0.9.13 \
    /bin/python3 manual_control.py
```
![img](Docs/imgs/srunner_manual_control.png)
*Note:* This is the manual_control from the scenario runner, not exactly the same one from carla/PythonAPI/example mentioned above.

The task of this scenario *FollowLeadingVehicle_1* is to drive behind the leading vehicle and finish the road segment. 

After finishing the task, or timed out (timer starts from scenario launch, **not** manual_control launch), the scenario will terminate itself.
