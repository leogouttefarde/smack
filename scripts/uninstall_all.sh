#! /bin/bash
# global uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

 # Uninstall each server
for SERV in "${NODES[@]}"; do

  echo "Uninstalling $SERV"
  remote_run $SERV ~/scripts/server_uninstall.sh

done

