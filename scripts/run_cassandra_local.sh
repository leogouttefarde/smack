#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

# If Cassandra node currently down, replace it
if ~/apache-cassandra-3.9/bin/nodetool status | grep $MY_IP | grep UN; then
  DEAD=0
else
  DEAD=1
  CENV=~/apache-cassandra-3.9/conf/cassandra-env.sh

  cp -f $CENV $CENV.old
  echo 'JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address='$MY_IP'"' >> $CENV
fi



# Xss = java thread stack size
# Xms = initial Java heap size
# Xmx = maximum Java heap size

# export JVM_OPTS="$JVM_OPTS Xss256k -Xms64m -Xmx256m"
export JVM_OPTS="$JVM_OPTS Xss1024k -Xms64m -Xmx512m"

echo "Running Cassandra on $SELF"

sudo $XNET/apache-cassandra-3.9/bin/cassandra -R -p ${PIDF_CASSANDRA} > $XNET/cassandra.log


# If Cassandra node currently down, finish repairing
if [ "$DEAD" -eq "1" ]; then

  ~/apache-cassandra-3.9/bin/nodetool repair
  mv -f $CENV.old $CENV

fi

