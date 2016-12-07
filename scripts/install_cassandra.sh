#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


SELF=$(hostname)

echo "Installation de python 2.7 sur $SELF"

cd ~/
sudo apt-get -y install build-essential checkinstall
sudo apt-get -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
cd /usr/src
sudo wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
sudo tar xzf Python-2.7.12.tgz
cd Python-2.7.12
sudo ./configure
sudo make altinstall


# Installation de JAVA

echo "Installation de java (oracle) sur $SELF"

cd ~/
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer


# Installation de CASSANDRA


CASSANDRA_LINK='http://apache.crihan.fr/dist/cassandra/3.9/apache-cassandra-3.9-bin.tar.gz'
CASSANDRA_TAR="${CASSANDRA_LINK##*/}"
CASSANDRA_DIRECTORY_NAME=${CASSANDRA_TAR%\-bin.tar.gz*}


echo "Installation de cassandra sur $SELF"


wget -P ~ ${CASSANDRA_LINK} 2>/dev/null
tar -xzf ~/${CASSANDRA_TAR}


cd ~/${CASSANDRA_DIRECTORY_NAME}/bin/


rm -f ~/${CASSANDRA_TAR}


echo "Configuration de Cassandra"
sed -r -i "s/cluster_name: '([a-zA-Z]| |_)*/cluster_name:'Smack_Cluster'/g" ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml
sed -r -i 's/- seeds: \"([0-9]{1,3}\.){3}[0-9]{1,3}\"/- seeds: ${MASTER}/g' ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml
sed -r -i 's/listen_address: (localhost|([0-9]{1,3}\.){3}[0-9]{1,3})/listen_address: ${SELF}/g' ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml
sed -r -i 's/rpc_address: (localhost|([0-9]{1,3}\.){3}[0-9]{1,3})/rpc_address: 0.0.0.0/g' ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml
sed -r -i '/^# broadcast_rpc_address:/s/^# //' ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml
sed -r -i 's/endpoint_snitch: [a-zA-Z]*/endpoint_snitch: RackInferringSnitch/g' ${CASSANDRA_DIRECTORY_NAME}/conf/cassandra.yaml

