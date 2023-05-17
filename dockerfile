FROM ubuntu:18.04
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y lsb-release libssl-dev 
# && apt-get clean all
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-get install -y curl gnupg wget locate
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN apt-get install -y ros-melodic-desktop-full

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

RUN apt install python-rosdep
RUN rosdep init
RUN rosdep update
RUN apt-get install -y git libglew-dev libpng-dev libjpeg-dev libtiff-dev libopenexr-dev liblz4-dev
RUN git clone https://github.com/stevenlovegrove/Pangolin.git
RUN cd Pangolin && mkdir build && cd build && cmake .. && cmake --build . \
&& make install -j100
RUN cd / && wget https://gitlab.com/libeigen/eigen/-/archive/3.3.8/eigen-3.3.8.tar.gz

RUN tar -zxvf  eigen-3.3.8.tar.gz
RUN cd eigen-3.3.8 && mkdir build && cd build && cmake .. && make install -j100
RUN ln -s /usr/local/include/eigen3 /usr/include/eigen3
RUN wget https://github.com/opencv/opencv/archive/refs/tags/3.2.0.tar.gz
RUN tar -zxvf 3.2.0.tar.gz && cd opencv-3.2.0 && mkdir build && cd build \
&& cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. -DENABLE_PRECOMPILED_HEADERS=OFF && make -j100 \
&& make install
RUN git clone https://github.com/UZ-SLAMLab/ORB_SLAM3.git

RUN echo "export  ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/ORB_SLAM3/Examples_old/ROS" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN mkdir -p /ORB_SLAM3/Thirdparty/DBoW2/build && cd /ORB_SLAM3/Thirdparty/DBoW2/build && cmake .. && make
RUN  mkdir -p /ORB_SLAM3/Thirdparty/Sophus/build && cd /ORB_SLAM3/Thirdparty/Sophus/build && cmake .. && make && make install
RUN mkdir -p /ORB_SLAM3/Thirdparty/g2o/build && cd /ORB_SLAM3/Thirdparty/g2o/build && cmake .. && make
COPY ./ORB_build_doc/ViewerAR.cc /ORB_SLAM3/Examples_old/ROS/ORB_SLAM3/src/AR/
COPY ./ORB_build_doc/ros_mono_ar.cc /ORB_SLAM3/Examples_old/ROS/ORB_SLAM3/src/AR/
COPY ./ORB_build_doc/build_ros.sh /ORB_SLAM3/build_ros.sh
COPY ./ORB_build_doc/CMakeLists.txt /ORB_SLAM3/CMakeLists.txt
RUN cd /ORB_SLAM3 && ./build.sh

# ENTRYPOINT ["/bin/bash", "cd ORB_SLAM3 && ./build_ros.sh"]

# RUN cd /ORB_SLAM3 && ./build_ros.sh
ENV ROS_ROOT=/opt/ros/melodic/share/ros
ENV PATH=/opt/ros/melodic/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONPATH=/opt/ros/melodic/lib/python2.7/dist-packages
ENV CMAKE_PREFIX_PATH=/opt/ros/melodic
ENV LD_LIBRARY_PATH=/opt/ros/melodic/lib
ENV ROS_PACKAGE_PATH=/opt/ros/melodic/share:/ORB_SLAM3/Examples_old/ROS
ENV ROS_ETC_DIR=/opt/ros/melodic/etc/ros
ENV PKG_CONFIG_PATH=/opt/ros/melodic/lib/pkgconfig
RUN  cd /ORB_SLAM3 && ./build_ros.sh


# ENV ROS_PACKAGE_PATH="/ORB_SLAM3/Examples_old/ROS/ORB_SLAM3/src:${ROS_PACKAGE_PATH}"
# ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/ros/melodic/bin"
# ENV PYTHONPATH="/opt/ros/melodic/lib/python2.7/dist-packages:${PYTHONPATH}"
# RUN  echo $ROS_ROOT && echo $ ROS_PACKAGE_PATH && echo $ROS_PACKAGE_PATH && echo $PATH &&  cd /ORB_SLAM3 && ./build_ros.sh