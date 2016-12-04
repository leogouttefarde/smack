# server installation script that installs everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# configure hosts
~/scripts/declare_hosts.sh

# Install Mesos & Spark
install_deps $(hostname)


SELF=$(hostname)

echo manual | sudo tee /etc/init/zookeeper.override &> /dev/null


if [[ $SELF = $MASTER ]]; then

  echo 'Configuration du master mesos'
  echo manual | sudo tee /etc/init/mesos-slave.override &> /dev/null

else

  echo "Configuration de l'esclave mesos "$SELF
  echo manual | sudo tee /etc/init/mesos-master.override &> /dev/null

fi


# Install Scala
sudo apt -y install scala


finish_server_install

