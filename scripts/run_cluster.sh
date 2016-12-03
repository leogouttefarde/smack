#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

echo 'Lancement du master'
ssh -q ${SSH_OPTS} ${NODES[0]} "bash -s > /dev/null 2>&1" < ./run_mesos_master.sh &
sleep 5
echo 'Lancement des esclaves'
for slave in "${NODES[@]:1}"
	do
        ssh -q ${SSH_OPTS} ${slave} "bash -s > /dev/null 2>&1" < ./run_mesos_slave.sh ${NODES[0]} &
	done