#! /bin/bash
# global installation script that installs everything, everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# Installs any not yet installed server
for SERV in "${NODES[@]}"; do

  echo "Installing $SERV"
  remote_run $SERV ~/scripts/server_install.sh

done

