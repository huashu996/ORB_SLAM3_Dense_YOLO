echo "Building ROS nodes"

cd Examples/ROS/YOLO_ORB_SLAM3_with_pointcloud_map
mkdir build
cd build
cmake .. -DROS_BUILD_TYPE=Release
make -j2
