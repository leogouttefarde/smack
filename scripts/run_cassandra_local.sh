#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Xss = java thread stack size
# Xms = initial Java heap size
# Xmx = maximum Java heap size

# export JVM_OPTS="$JVM_OPTS Xss256k -Xms64m -Xmx256m"
export JVM_OPTS="$JVM_OPTS Xss256m -Xms64m -Xmx512m"

echo "Running Cassandra on $SELF"
# echo "PIDF_CASSANDRA = $PIDF_CASSANDRA"

sudo ~/apache-cassandra-3.9/bin/cassandra -f -R > cassandra.log &
# sudo ~/apache-cassandra-3.9/bin/cassandra -f -R -p ${PIDF_CASSANDRA} > cassandra.log &

