## 简介
此项目在ORB-SLAM3的基础上添加了稠密建图和目标识别模块
## 环境配置
详情见https://blog.csdn.net/HUASHUDEYANJING/article/details/129053124?spm=1001.2014.3001.5501
针对ubuntu20.04做了相应的修改
使用RealsenseD435 RGBD相机
opencv 4.2
Pangolin 0.6
- Install libtorch
```bash
wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcpu.zip
unzip libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcpu.zip
mv libtorch/ PATH/YOLO_ORB_SLAM3/Thirdparty/
```
## 编译
- 加入ROS环境
```
gedit ~/.bashrc
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:/home/cxl/workspace/ORB_SLAM3_Dense_YOLO/Examples/ROS/YOLO_ORB_SLAM3_with_pointcloud_map
source ~/.bashrc
```
- 编译
```
chmod +x build.sh
chmod +x build_ros.sh
./build.sh
./build_ros.sh
```
## 运行RGBD稠密建图
- 话题
一定得用aligned后的深度图，否则三维重建的效果很差
```
ros::NodeHandle nh;
message_filters::Subscriber<sensor_msgs::Image> rgb_sub(nh, "/camera/color/image_rect_color", 100);
message_filters::Subscriber<sensor_msgs::Image> depth_sub(nh, "/camera/aligned_depth_to_color/image_raw", 100);
typedef message_filters::sync_policies::ApproximateTime<sensor_msgs::Image, sensor_msgs::Image> sync_pol;
message_filters::Synchronizer<sync_pol> sync(sync_pol(10), rgb_sub,depth_sub);
sync.registerCallback(boost::bind(&ImageGrabber::GrabRGBD,&igb,_1,_2));
```
- 运行
```
roslaunch realsense2_camera rs_rgbd.launch align_depth:=true
roslaunch YOLO_ORB_SLAM3_with_pointcloud_map camera_topic_remap.launch
rosrun ORB_SLAM3_Dense_YOLO RGBD Vocabulary/ORBvoc.txt Examples/RGB-D/RealSense_D435i.yaml
```
