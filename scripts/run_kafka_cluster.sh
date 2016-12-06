#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

NBR_KAFKA_BROKERS=$1


#Lancement du scheduler kafka
remote_run ${MASTER} "cd ~/kafka && ./kafka-mesos.sh scheduler"

sleep 5

#Lancement des brokers
remote_run_sync ${MASTER} "cd ~/kafka && ./kafka-mesos.sh broker add 1..$NBR_KAFKA_BROKERS --mem 256 --heap 256"
remote_run_sync ${MASTER} "cd ~/kafka && ./kafka-mesos.sh broker start 1..$NBR_KAFKA_BROKERS"
