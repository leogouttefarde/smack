#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


if [ $# -ge 1 ]; then

  echo 'Arret du master mesos'

  sudo kill $(sudo lsof -t -i:5050) &>/dev/null
  sudo service zookeeper stop &>/dev/null

else

  echo "Arret de l'esclave mesos $(hostname)"
#  remote_run ${slave} 'sudo kill $(sudo lsof -t -i:5051)'

  sudo kill $(sudo lsof -t -i:5051) &>/dev/null

fi
