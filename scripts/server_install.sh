# server installation script that installs everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Abort if already installed
check_installed


# configure hosts
~/scripts/declare_hosts.sh


SELF=$(hostname)


# Install Mesos, Spark, Kafka
install_deps $SELF


echo manual | sudo tee /etc/init/zookeeper.override > /dev/null


if [[ ${SELF} = ${MASTER} ]]; then

  echo 'Configuration du master mesos'
  echo manual | sudo tee /etc/init/mesos-slave.override > /dev/null
  echo 1 | sudo tee /etc/zookeeper/conf/myid > /dev/null
  printf "\nserver.1="${MASTER}":2888:3888" | sudo tee --append /etc/zookeeper/conf/zoo.cfg > /dev/null

else

  echo "Configuration de l'esclave mesos "$SELF
  echo manual | sudo tee /etc/init/mesos-master.override > /dev/null

fi


finish_server_install

echo "Installation du serveur $SELF terminée"

