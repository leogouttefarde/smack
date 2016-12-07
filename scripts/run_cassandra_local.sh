#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


export JVM_OPTS="$JVM_OPTS Xss256k -Xms64m -Xmx256m"

sudo ~/apache-cassandra-3.9/bin/cassandra -f -R > cassandra.log &

