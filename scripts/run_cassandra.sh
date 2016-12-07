#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


JVM_OPTS="$JVM_OPTS Xss256k -Xms64m -Xmx256m"

~/apache-cassandra-3.9/bin/cassandra -f > /dev/null

