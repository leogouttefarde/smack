#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Kill the Cassandra process
sudo kill $(cat $PIDF_CASSANDRA 2>/dev/null) &>/dev/null

# Look for Cassandra process and kills it (if any left)
sudo pkill -f 'java.*cassandra' &>/dev/null


# Clean Cassandra data
sudo rm -rf $XNET/apache-cassandra-3.9/data/* &>/dev/null


echo "Cassandra killed on $(hostname)"

