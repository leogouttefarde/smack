#! /bin/bash
# Manual hosts uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# reset each server
for SERV in "${NODES[@]}"; do

  if [[ $(hostname) = "$SERV" ]]; then
    SELF=$SERV
  else
    echo "Uninstalling hosts on $SERV"
    remote_run $SERV "~/scripts/declare_hosts.sh undo"
  fi

done

echo "Uninstalling hosts on $SELF"
~/scripts/declare_hosts.sh undo

