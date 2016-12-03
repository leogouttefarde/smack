#! /bin/bash
# Installs hosts everywhere (for manual usage)

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# install each server
for i in {1..4}; do

  SERV=server-$i

  echo "Installing hosts on $SERV"
  remote_run $SERV ~/scripts/declare_hosts.sh

done


