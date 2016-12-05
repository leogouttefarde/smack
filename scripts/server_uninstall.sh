# Server uninstallation script that uninstalls everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Remove Spark, Mesos, Kafka, Zookeeper
rm -rf spark-2.0.2-bin-hadoop2.7

sudo apt-get -y remove mesos

sudo apt-get -y remove zookeeper

sudo rm /etc/apt/sources.list.d/mesosphere.list

sudo apt-key del E56151BF

sudo rm -f /etc/init/mesos-*.override /etc/init/zookeeper.override

sudo rm -rf ~/kafka


# Remove Scala
sudo apt-get -y remove scala

sudo apt-get -y autoremove


# Uninstall hosts once the rest is finished
~/scripts/declare_hosts.sh undo


finish_server_uninstall

