# server installation script that installs everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# configure hosts
~/scripts/declare_hosts.sh


SELF=$(hostname)


# Install Mesos & Spark
install_deps $SELF


echo manual | sudo tee /etc/init/zookeeper.override &> /dev/null


if [[ $SELF = $MASTER ]]; then

  echo 'Configuration du master mesos'
  echo manual | sudo tee /etc/init/mesos-slave.override &> /dev/null

else

  echo "Configuration de l'esclave mesos "$SELF
  echo manual | sudo tee /etc/init/mesos-master.override &> /dev/null

fi


finish_server_install

