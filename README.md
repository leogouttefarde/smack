# SMACK

## Installation setup

### First setup

To download and extract the installation files the first time, just run this command :

`ZIP=~/setup.zip; cd ~; wget -O $ZIP https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip; unzip -o $ZIP`

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

### Launching mesos cluster

Run `~/scripts/run_mesos_cluster.sh`

### Launching Kafka cluster

The number of kafka brokers is configured through the script argument

Run `~/scripts/run_kafka_cluster.sh <NBR_KAFKA_BROKERS>`

## Cluster stopping scripts

### Stopping mesos cluster

Run `~/scripts/stop_mesos_cluster.sh`

### Stopping Kafka cluster

Run `~/scripts/stop_kafka_cluster.sh`
