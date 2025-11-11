# from ros 2 humble base image
FROM osrf/ros:humble-desktop

ENV DEBIAN_FRONTEND=noninteractive

## The following installs gazebo harmonic, for humble compatibility
###################################################################

# install stuff
RUN apt-get update && apt-get install -y python3-pip python3-venv lsb-release gnupg curl git


# install vcstool and colcon from pip
RUN python3 -m venv $HOME/vcs_colcon_installation && \
    . $HOME/vcs_colcon_installation/bin/activate && \
    pip3 install vcstool colcon-common-extensions


# gazebo install? TODO make nicer stup with basic version checking
RUN mkdir -p /ws_gazebo/src && \
    cd /ws_gazebo/src && \
    curl -O https://raw.githubusercontent.com/gazebo-tooling/gazebodistro/master/collection-harmonic.yaml && \
    vcs import < collection-harmonic.yaml && \
    curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && \
    apt -y install \
    $(sort -u $(find . -iname 'packages-'`lsb_release -cs`'.apt' -o -iname 'packages.apt' | grep -v '/\.git/') | sed '/gz\|sdf/d' | tr '\n' ' ') && \
    cd /ws_gazebo && colcon build --cmake-args ' -DBUILD_TESTING=OFF' --merge-install
    # source /ws_gazebo/install/setup.bash in bashrc

# install lcm
RUN git clone --branch v1.5.2 https://github.com/lcm-proj/lcm.git /lcm && cd /lcm && \
    mkdir build && cd build && cmake .. && make -j4 && make install

# install nav2 NOTE: humble hardcoded so this code fails/screams in agony if used with other ROS distros
# this entire installation is meant to be tightly coupled ROS humble-gazebo (harmonic ?)

# set shell to be bash
SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/humble/setup.bash && \
    apt-get install -y \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers

# a bit weird: remove installed versioned libdart, and install unversioned libdart-dev to avoid conflicts
RUN apt remove --purge -y libdart6.13-dev libdart6.13-external-convhull-3d-dev libdart6.13-external-odelcpsolver-dev && \
    apt update && \
    apt install -y libdart-dev && \
    apt install -y \
    ros-humble-gazebo-plugins \
    ros-humble-xacro \
    ros-humble-gazebo-ros2-control

# Copy .bashrc for interactive shell setup (works with docker exec)
COPY .bashrc /root/.bashrc
