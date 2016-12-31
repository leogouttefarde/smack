#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Changement si argument spécifié
if [[ $# -ge 1 ]]; then

  remote_run_sync $1 ~/scripts/kill_mesos_local.sh

else

  echo "Il faut fournir en argument le serveur concerné"

fi

