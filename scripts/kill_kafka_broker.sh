#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Changement si argument spécifié
if [[ $# -ge 1 ]]; then

  echo "Arret du broker $1"
  remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/stop?broker='$1'" &>/dev/null'

  echo "Suppression du broker $1"
  remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/remove?broker='$1'" &>/dev/null'

else

  echo "Il faut fournir en argument le numéro du broker à tuer (en partant de 1)"

fi


