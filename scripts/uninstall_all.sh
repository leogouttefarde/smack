#! /bin/bash
# global uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# reset each server
for i in {1..4}; do

  ssh ${SSH_OPTS} xnet@server-$i "~/scripts/declare_hosts.sh undo"

done


