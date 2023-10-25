# rob750_docker

There is an example on launching/running from anorther launch file
https://github.com/SICKAG/sick_scan_xd/blob/master/FAQ.md#how-to-run-multiple-sensors-concurrently

On spots payload network the spot core have the ip address 192.168.50.5 and lidar 192.168.50.6
## the enviroment variable can be better handle if we can get docker compose on the spot core and a better wifi. think we will need the cmd duration to be higher, have some strange movement some time. maybe we shall se if the lidar works if the get back on the port on the spot core (maybe that will limit the trafic over spots intaernal network)

### 1. SSH into SPOT CORE
    ssh -p 20022 spot@192.168.80.3

### 2. Run docker images to be able to see topic on your laptop (some ros2 cli do not work ex. ros2 topic list)
    docker run -it --user ros --network=host --ipc=host --name=ros_fastdds_discovery_server rob750

    fastdds discovery -i 0 -p 21000

### 3. Run Spot Ros2 image (here can you launch spot driver or lidar)
    ### first ssh into the spot core ###

    cd rob750_docker
    docker run -it --user ros --network=host --ipc=host -v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY --name=spot_ros2 -v $PWD/source:/home/workspaces rob750

    ### do next two lines in every terminal in this cotainer that you opens ###
    export ROS_DISCOVERY_SERVER=192.168.80.3:21000
    export ROS_DOMAIN_ID=56

    ### lidar ###
    cd /home/sick_ws
    ros2 run sick_scan_xd sick_generic_caller ./src/sick_scan_xd/launch/sick_tim_5xx.launch hostname:=192.168.50.6
    ### ###

    ### spot driver ###
    cd /home/workspaces/rob7_750
    . install/setup.bash
    ros2 launch spot_rob750 spot_launch.py
    ### ###

### 4. connect terminal on your own pc
    sudo ip route add 192.168.50.5 via 192.168.80.3  # think you only have to do this onces
    export ROS_DISCOVERY_SERVER=192.168.80.3:21000
### 5. run teleop-twist-keyboard
    ros2 run teleop_twist_keyboard teleop_twist_keyboard
