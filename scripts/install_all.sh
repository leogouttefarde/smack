#! /bin/bash
# global installation script that installs everything, everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# Installs any not yet installed server
for MASTER in "${MASTERS[@]}"; do

  echo "Installing $MASTER"
  remote_run $MASTER "~/scripts/server_install.sh im_a_master"

done

for SLAVE in "${SLAVES[@]}"; do

  echo "Installing $SLAVE"
  remote_run $SLAVE ~/scripts/server_install.sh

done