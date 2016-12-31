#! /bin/bash
# Runs commands on all servers

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Display help on missing argument
if [[ $# -ge 1 ]]; then

  run_cmd_all $1

else

  echo "Il faut fournir en argument la commande à lancer sur les serveurs"

fi

