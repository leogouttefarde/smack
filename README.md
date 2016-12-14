# SMACK

## Installation setup

### First setup

To download and extract the installation files for the first time, just run this command :

`ZIP=~/setup.zip; cd ~; wget -O $ZIP https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip; sudo apt -y install unzip; unzip -o $ZIP`

### Further updates

To check for new installation updates, run `~/scripts/update_setup.sh`

## Installation scripts

### Installation

Run `~/scripts/install_all.sh`

### Uninstallation

Run `~/scripts/uninstall_all.sh`

### Display setup version hash

Run `~/scripts/version.sh`

## Cluster launching scripts

### Launching Mesos cluster

Run `~/scripts/run_mesos_cluster.sh`

### Launching Kafka cluster

The number of kafka brokers is configured through the script argument

Run `~/scripts/run_kafka_cluster.sh <NB_KAFKA_BROKERS>`

### Launching Cassandra cluster

Run `~/scripts/run_cassandra_cluster.sh &`


## Cluster stopping scripts

### Stopping Mesos cluster

Run `~/scripts/stop_mesos_cluster.sh`

### Stopping Kafka cluster

Run `~/scripts/stop_kafka_cluster.sh`

### Stopping Cassandra cluster

Run `~/scripts/stop_cassandra_cluster.sh`


## Server killing scripts

### Killing Mesos from a server

Run `~/scripts/kill_mesos_server.sh <server>`

### Killing Cassandra from a server

Run `~/scripts/kill_cassandra_server.sh <server>`

### Killing Kafka from a broker

Run `~/scripts/kill_kafka_broker.sh <brokerNumber>`

### Lanching the app_demo 
cd ~/app_demo
sudo ../spark-2.0.2-bin-hadoop2.7/bin/spark-submit --packages datastax:spark-cassandra-connector:2.0.0-M2-s_2.11  --class "SimpleApp" --master mesos://zk://server-1:2181/mesos target/scala-2.11/simple-project_2.11-1.0.jar

