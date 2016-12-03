#! /bin/bash
# Manual hosts uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# reset each server
for i in {1..4}; do

  SERV=server-$i

  if [[ $(hostname) = "$SERV" ]]; then
    SELF=$SERV
  else
    echo "Uninstalling hosts on $SERV"
    remote_run $SERV "~/scripts/declare_hosts.sh undo"
  fi

done

echo "Uninstalling hosts on $SELF"
~/scripts/declare_hosts.sh undo

