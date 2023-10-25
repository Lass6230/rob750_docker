#!/bin/bash

set -e

source /opt/ros/humble/setup.bash
source /home/workspaces/rob7_750/install/setup.bash

echo "Provided arguments: $@"

exec $@