#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Changement si argument spécifié
if [[ $# -ge 1 ]]; then

echo "Arret et suppression des brokers $1"
curl "http://localhost:7000/api/broker/stop?broker='$1'" &>/dev/null
curl "http://localhost:7000/api/broker/remove?broker='$1'" &>/dev/null

else

  echo "Il faut fournir en argument le numéro du broker à tuer (en partant de 1)"

fi


