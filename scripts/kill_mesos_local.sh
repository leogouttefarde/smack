#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


if [[ $(hostname) = "$MASTER" ]]; then
  echo 'Arret du master'
  remote_run_sync ${MASTER} 'sudo kill $(sudo lsof -t -i:5050)'
  remote_run_sync ${MASTER} 'sudo service zookeeper stop'
else
  echo "Arret de l'esclave $(hostname)"
  remote_run ${slave} 'sudo kill $(sudo lsof -t -i:5051)'
fi

