#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Lancement du seeder cassandra
remote_run ${MASTER} "~/scripts/run_cassandra_local.sh"

sleep 5


# Lancement des autres
for slave in ${SLAVES}; do
  remote_run ${slave} "~/scripts/run_cassandra_local.sh"
done

