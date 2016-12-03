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
    echo "Resetting $SERV"
    remote_run $SERV "~/scripts/declare_hosts.sh undo"
  fi

done

echo "Resetting $SELF"
~/scripts/declare_hosts.sh undo


# Remove Spark & Mesos
rm -rf spark-2.0.2-bin-hadoop2.7

sudo apt-get -y remove mesos

rm /etc/apt/sources.list.d/mesosphere.list

sudo apt-key del E56151BF

rm -f /etc/init/mesos-*.override /etc/init/zookeeper.override



# Remove Scala
sudo apt -y remove scala


