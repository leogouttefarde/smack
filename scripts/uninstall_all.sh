#! /bin/bash
# global uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# reset each server
for i in {1..4}; do

  SERV=server-$i

  if [[ $(hostname) = "$SERV" ]]; then
    SELF=$SERV
  else
    ssh ${SSH_OPTS} xnet@$SERV "~/scripts/declare_hosts.sh undo"
  fi

done

~/scripts/declare_hosts.sh undo

