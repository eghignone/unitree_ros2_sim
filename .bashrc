# ROS 2 Humble setup for container
# This file is sourced by interactive bash shells

# Source ROS 2 Humble
if [ -f /opt/ros/humble/setup.bash ]; then
    source /opt/ros/humble/setup.bash
fi

# Source Gazebo workspace if it exists
if [ -f /ws_gazebo/install/setup.bash ]; then
    source /ws_gazebo/install/setup.bash
fi

# Set up colorful bash prompt
# Colors: green for user@host, blue for directory, cyan for ROS distro
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;36m\] [ROS2:$ROS_DISTRO]\[\033[00m\]\$ '

# Enable colored ls output
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'

alias sauce='source /workspace/install/setup.bash'

# Colored grep
alias grep='grep --color=auto'

# Enable bash completion if available
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# Print welcome message with colors (only for interactive shells)
if [[ $- == *i* ]]; then
    echo -e "\033[1;36m========================================\033[0m"
    echo -e "\033[1;32mROS 2 Humble Development Container\033[0m"
    echo -e "\033[1;36m========================================\033[0m"
    echo -e "ROS_DISTRO: \033[1;33m$ROS_DISTRO\033[0m"
    echo -e "Workspace: \033[1;34m/workspace/src\033[0m"
    echo -e "\033[1;36m========================================\033[0m"
fi
