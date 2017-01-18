#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

echo 'Available brokers'
cd ~/kafka && ./kafka-mesos.sh broker list

echo 'Enter the broker id: '
read BROKER

export BROKER

echo 'Enter the name of the topic: '
read TOPIC_NAME

export TOPIC_NAME

echo 'Enter the number of replicas: '
read REPLICAS

if [[ ${BROKER} != '' ]] && [[ ${TOPIC_NAME} != '' ]];then
    cd ~/kafka && ./kafka-mesos.sh topic add $TOPIC_NAME --broker $BROKER --replicas $REPLICAS
else
    echo 'Invalid input. Aborting ...'
fi
