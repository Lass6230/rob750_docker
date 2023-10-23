# FROM ros:humble
# or
FROM osrf/ros:humble-desktop-full
# Example of installing programs
RUN apt-get update \
    && apt-get install -y \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Example of copying a file
COPY config/ /site_config/


# Create a non-root user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config


# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*



RUN apt-get update && apt-get install -y ros-humble-ros-base \
    # ros-humble-angles \
    # ros-humble-apriltag \
    # ros-humble-behaviortree-cpp-v3 \
    # ros-humble-bondcpp \
    # ros-humble-camera-calibration-parsers \
    # ros-humble-camera-info-manager \
    # ros-humble-compressed-image-transport \
    # ros-humble-compressed-depth-image-transport \
    # ros-humble-cv-bridge \
    # ros-humble-demo-nodes-cpp \
    # ros-humble-demo-nodes-py \
    # ros-humble-diagnostic-updater \
    # ros-humble-example-interfaces \
    # ros-humble-foxglove-bridge \
    # ros-humble-image-geometry \
    # ros-humble-image-pipeline \
    # ros-humble-image-transport \
    # ros-humble-image-transport-plugins \
    # ros-humble-launch-xml \
    # ros-humble-launch-yaml \
    # ros-humble-launch-testing \
    # ros-humble-launch-testing-ament-cmake \
    ros-humble-nav2-bringup \
    ros-humble-nav2-msgs \
    ros-humble-nav2-mppi-controller \
    ros-humble-navigation2 \
    ros-humble-ompl \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    # ros-humble-resource-retriever \
    # ros-humble-rqt-graph \
    # ros-humble-rqt-reconfigure \
    # ros-humble-rqt-image-view \
    # ros-humble-rviz2 \
    # ros-humble-rviz-common \
    # ros-humble-rviz-default-plugins \
    ros-humble-sensor-msgs \
    ros-humble-slam-toolbox \
    # ros-humble-v4l2-camera \
    # ros-humble-vision-opencv \
    # ros-humble-vision-msgs \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Should make you able to talk to serial devices
RUN usermod -aG dialout ${USERNAME} 


# Copy the entrypoint and bashrc scripts so we have 
# our container's environment set up correctly
COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc




# Set up entrypoint and default command
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]