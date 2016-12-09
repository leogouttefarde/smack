#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

#Arret des esclaves
echo 'Arret des esclaves'
for slave in ${SLAVES}; do
  remote_run ${slave} ~/scripts/kill_mesos_local.sh
done

#Arret du scheduler
echo 'Arret du master'
remote_run ${MASTER} ~/scripts/kill_mesos_local.sh
