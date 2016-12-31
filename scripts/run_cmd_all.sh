#! /bin/bash
# Updates the setup files everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Changement si argument spécifié
if [[ $# -ge 1 ]]; then

  run_cmd_all $1

else

  echo "Il faut fournir en argument la commande à lancer sur les serveurs"

fi

