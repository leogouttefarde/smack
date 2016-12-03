#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo 'Lancement du master'
remote_run_sync $MASTER ~/scripts/run_mesos_master.sh

#sleep 5


echo 'Lancement des esclaves'

for slave in ${SLAVES}
  do
    remote_run ${slave} "~/scripts/run_mesos_slave.sh $MASTER"
  done

