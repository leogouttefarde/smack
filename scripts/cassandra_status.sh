#! /bin/bash
# Runs commands on all servers

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


~/apache-cassandra-3.9/bin/nodetool status
