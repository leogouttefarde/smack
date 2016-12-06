#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

#Arret des esclaves
echo 'Arret des esclaves'
for slave in ${SLAVES}
  do
    remote_run ${slave} 'sudo kill $(sudo lsof -t -i:5051)'
  done

#Arret du scheduler
echo 'Arret du master'
remote_run_sync ${MASTER} 'sudo kill $(sudo lsof -t -i:5050)'
