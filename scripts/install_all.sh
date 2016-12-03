#! /bin/bash
# global installation script that installs everything, everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

# Abort if already installed
if is_installed ; then

  echo "This server is already installed, aborting"
  exit

fi

setup_res

# install each server
for i in {1..4}; do

  SERV=server-$i

  echo "Installing $SERV"
  remote_run $SERV ~/scripts/server_install.sh

done


