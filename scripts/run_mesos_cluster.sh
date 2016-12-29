#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

CURRENT_MESOS_INSTANCE_PID=$(sudo lsof -t -i:5050)

if [[ ${CURRENT_MESOS_INSTANCE_PID} -ne '' ]];then
    echo 'Mesos cluster already running. Aborting...'
    exit
fi

echo 'Lancement du master'

for MASTER in ${MASTERS}
  do
    remote_run ${MASTER} ~/scripts/run_mesos_master.sh
  done

sleep 5


echo 'Lancement des esclaves'

for slave in ${SLAVES}
  do
    remote_run ${slave} "~/scripts/run_mesos_slave.sh $MASTER"
  done

