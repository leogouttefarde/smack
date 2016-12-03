# server installation script that installs everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Remove Spark & Mesos
rm -rf spark-2.0.2-bin-hadoop2.7

sudo apt-get -y remove mesos

sudo rm /etc/apt/sources.list.d/mesosphere.list

sudo apt-key del E56151BF

sudo rm -f /etc/init/mesos-*.override /etc/init/zookeeper.override


# Remove Scala
sudo apt -y remove scala


# Uninstall hosts once the rest is finished
~/scripts/declare_hosts.sh undo

