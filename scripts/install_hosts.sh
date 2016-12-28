#! /bin/bash
# Installs hosts everywhere (for manual usage)

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# install each server
for SERV in "${NODES[@]}"; do

  echo "Installing hosts on $SERV"
  remote_run $SERV ~/scripts/declare_hosts.sh

done


