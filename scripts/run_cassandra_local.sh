#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Running Cassandra on $SELF"

DEAD=0

# On regarde si un noeud cassandra nous connaît,
# si oui alors on doit remplacer le processus mort
# si non on doit démarrer normalement
for SERV in "${NODES[@]}"; do

    if remote_run_sync $SERV "~/scripts/cassandra_status.sh | grep $MY_IP" 2>/dev/null; then
      DEAD=1;
      break;
    fi

done


if [ $DEAD -eq 1 ]; then

  echo "Replacing dead node"

  CENV=$XNET/apache-cassandra-3.9/conf/cassandra-env.sh

  cp -f $CENV $CENV.old
  sudo chmod 666 $CENV
  echo 'JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address='$MY_IP'"' >> $CENV
  sudo chmod 644 $CENV

else

  echo "Starting node"

fi



# Xss = java thread stack size
# Xms = initial Java heap size
# Xmx = maximum Java heap size

# export JVM_OPTS="$JVM_OPTS Xss256k -Xms64m -Xmx256m"
export JVM_OPTS="$JVM_OPTS -Xss1024k -Xms64m -Xmx512m"

sudo rm $XNET/cassandra.log
sudo $XNET/apache-cassandra-3.9/bin/cassandra -R -p ${PIDF_CASSANDRA} > $XNET/cassandra.log


# If Cassandra node currently down, finish repairing
if [ $DEAD -eq 1 ]; then

  sleep 4

  $XNET/apache-cassandra-3.9/bin/nodetool repair
  mv -f $CENV.old $CENV

fi

