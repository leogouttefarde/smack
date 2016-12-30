# Server uninstallation script that uninstalls everything for a single machine

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Remove Cassandra
sudo apt-get -y remove build-essential checkinstall
sudo apt-get -y remove libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

sudo add-apt-repository -y --remove ppa:webupd8team/java
sudo apt-get -y remove oracle-java8-installer

# restore default monit config
sudo mv /etc/monit/monitrc{.old,}

sudo service monit stop

sudo apt-get -y remove monit



# Remove Spark, Mesos, Kafka, Zookeeper
rm -rf spark-2.0.2-bin-hadoop2.7

# Remove Scala
sudo apt-get -y remove scala

# sudo apt-get -y remove marathon

sudo apt-get -y remove zookeeper

sudo rm /etc/apt/sources.list.d/mesosphere.list

sudo apt-key del E56151BF

sudo rm -f /etc/init/mesos-*.override /etc/init/zookeeper.override

sudo rm -rf ~/kafka

sudo apt-get -y remove openjdk-8-jdk

sudo apt-get -y remove mesos

sudo apt-get -y autoremove


# Uninstall hosts once the rest is finished
~/scripts/declare_hosts.sh undo


finish_server_uninstall

echo "Désinstallation du serveur $SELF terminée"

