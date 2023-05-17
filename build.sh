docker rm -f orb_slam3
docker build -t orb_slam_buntu_melodic . 
docker run -dit --privileged  --ipc=host --net=host -v  $(pwd):/home  --group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix  --env="DISPLAY=$DISPLAY" \
--env="QT_X11_NO_MITSHM=1"  --device=/dev/dri:/dev/dri \
--name orb_slam3 orb_slam_buntu_melodic

# --no-cache
#  docker run -dit --name=orb_slam3 -v {}:{} -v /tmp/.X11-unix:/tmp/.X11-unix  -v /dev/dri:/dev/dri --device /dev/snd -e DISPLAY=unix$DISPLAY  orb_slam_buntu_melodic


# xhost +local:docker

# docker run -dit --name orb_slam3 \
# -v /tmp/.X11-unix:/tmp/.X11-unix \
# -v ~/.Xauthority:/.Xauthority \
# -v /dev/dri:/dev/dri \
# --device /dev/snd \
# --net=host \
# -e DISPLAY=unix$DISPLAY \
# -e XAUTHORITY=/.Xauthority \
# --env="QT_X11_NO_MITSHM=1" \
# fishros2/ros:melodic-desktop-full


# sudo docker run -it -v /home/nuc/noetic_container_data_1:/data --device=/dev/dri --group-add video --volume=/tmp/.X11-unix:/tmp/.X11-unix  --env="DISPLAY=$DISPLAY" --env="QT_X11_NO_MITSHM=1" --name=noetic_ros_2 osrf/ros:melodic-desktop-full  /bin/bash


# docker run -dit --name orb_slam3 \
# -v /tmp/.X11-unix:/tmp/.X11-unix \
# -v ~/.Xauthority:/.Xauthority \
# -v /dev/dri:/dev/dri \
# --device /dev/snd \
# --net=host \
# -e DISPLAY=unix$DISPLAY \
# -e XAUTHORITY=/.Xauthority \
# fishros2/ros:melodic-desktop-full