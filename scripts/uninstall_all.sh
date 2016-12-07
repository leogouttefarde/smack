#! /bin/bash
# global uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

 # Uninstall each server
for i in {1..4}; do

  SERV=server-$i

  echo "Uninstalling $SERV"
  remote_run $SERV ~/scripts/server_uninstall.sh

done

