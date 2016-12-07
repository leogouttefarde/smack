#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Lancement du seeder cassandra
remote_run_sync ${MASTER} "~/apache-cassandra-3.9/bin/cassandra -f > /dev/null"


# Lancement des autres
for slave in ${SLAVES}; do
  remote_run ${slave} "~/apache-cassandra-3.9/bin/cassandra -f > /dev/null"
done

