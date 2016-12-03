
install_deps $(hostname)

echo manual | sudo tee /etc/init/zookeeper.override &> /dev/null
echo manual | sudo tee /etc/init/mesos-master.override &> /dev/null
