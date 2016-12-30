#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

CURRENT_KAFKA_INSTANCE_PID=$(sudo lsof -t -i:7000)

if [[ ${CURRENT_KAFKA_INSTANCE_PID} -ne '' ]];then
    echo 'Kafka cluster already running. Aborting...'
    exit
fi

# Nombre par défaut
NB_KAFKA_BROKERS=1

# Changement si argument spécifié
if [[ $# -ge 1 ]]; then
  NB_KAFKA_BROKERS=$1
fi


# Lancement du scheduler kafka
echo 'Lancement du scheduler kafka'
remote_run ${MASTER[0]} "cd ~/kafka && ./kafka-mesos.sh scheduler > /dev/null 2>&1"

sleep 5

# Lancement des brokers
echo 'Lancement des brokers'
remote_run_sync ${MASTER[0]} "cd ~/kafka && ./kafka-mesos.sh broker add 1..$NB_KAFKA_BROKERS --cpus 0.5 --mem 256 --heap 256  > /dev/null 2>&1"
remote_run_sync ${MASTER[0]} "cd ~/kafka && ./kafka-mesos.sh broker start 1..$NB_KAFKA_BROKERS  > /dev/null 2>&1"
