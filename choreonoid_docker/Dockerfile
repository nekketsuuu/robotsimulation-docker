FROM osrf/ros:indigo-desktop-full

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"

# set environment variables
ENV CNOID_INSTALL_DIR /usr/local/choreonoid
ENV PATH /usr/local/nvidia/bin:${CNOID_INSTALL_DIR}/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${CNOID_INSTALL_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
ENV WORKHOME /home/choreonoid

# install packages for choreonoid
RUN set -eu \
 && apt-get update -y \
 && apt-get install -y \
      libyaml-dev \
      mesa-utils \
      python-pip \

# ros pkg
 && mkdir -p /home/choreonoid/catkin_ws \
 && cd /home/choreonoid/catkin_ws \
 && wstool init src \
#&& wstool set -y -t src rtmros_choreonoid https://github.com/YoheiKakiuchi/rtmros_choreonoid.git --git -v docker_test \
 && wstool set -y -t src rtmros_choreonoid https://github.com/start-jsk/rtmros_choreonoid.git --git \
 && wstool set -y -t src rtmros_tutorials https://github.com/start-jsk/rtmros_tutorials.git --git \
 && wstool set -y -t src rtmros_common https://github.com/start-jsk/rtmros_common --git \
 && wstool set -y -t src hrpsys https://github.com/fkanehiro/hrpsys-base.git --git \
 && wstool set -y -t src jsk_common https://github.com/jsk-ros-pkg/jsk_common.git --git \
 && wstool set -y -t src pr2_navigation https://github.com/PR2/pr2_navigation.git --git \
 && wstool update -t src \
 && git clone --depth=1 https://github.com/jsk-ros-pkg/jsk_robot.git src/jsk_robot \
 && (cd src/jsk_robot && rm -rf README.md jsk_baxter_robot jsk_naoqi_robot jsk_robot doc jsk_fetch_robot jsk_pr2_robot) \
 && rosdep install -y -r --from-paths src --ignore-src \

### should be solved ...,  hrpsys-base, jsk_common, pr2_navigation ###
 && apt-get install -y \
      ros-indigo-jsk-recognition \
      ros-indigo-jsk-tilt-laser \

# build choreonoid
 && mkdir -p /home/choreonoid/src \
 && cd /home/choreonoid/src \
 && git clone --depth=1 https://github.com/s-nakaoka/choreonoid.git \
 && mkdir -p choreonoid/build \
 && cd choreonoid/build \
 && cmake .. \
      -DCMAKE_INSTALL_PREFIX=${CNOID_INSTALL_DIR} \
      -DENABLE_INSTALL_RPATH=ON \
      -DENABLE_CORBA=ON \
      -DBUILD_CORBA_PLUGIN=ON \
      -DBUILD_OPENRTM_PLUGIN=ON \
      -DBUILD_HELLO_WORLD_SAMPLE=ON \
      -DBUILD_SPRING_MODEL_SAMPLE=ON \
      -DBUILD_PYTHON_PLUGIN=ON \
      -DBUILD_PYTHON_SIM_SCRIPT_PLUGIN=ON \
      -DOPENRTM_DIR=/opt/ros/indigo \
 && make -j4 \
 && make install \

# build ros packages
 && cd /home/choreonoid/catkin_ws \
 && /bin/bash -c \
      "source /opt/ros/$ROS_DISTRO/setup.bash \
    && catkin build hrpsys_choreonoid_tutorials jsk_robot_startup jsk_tilt_laser pr2_navigation_self_filter --no-status --no-notify -j 1 -p 1" \

# run choreonoid
 && /bin/bash -c \
      "source /home/choreonoid/catkin_ws/devel/setup.bash \
    && rosrun roseus generate-all-msg-srv.sh geometry_msgs sensor_msgs hrpsys_ros_bridge opencv_apps" \

# clear cache
 && rm -rf \
      /home/choreonoid/src \
      /home/choreonoid/catkin_ws/build \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD ./my_entrypoint.sh /

ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
