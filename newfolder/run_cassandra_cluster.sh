#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Lancement des seeders cassandra
for MASTER in "${MASTERS[@]}"; do
  remote_run ${MASTER} "~/scripts/run_cassandra_local.sh"
done

sleep 10

# Lancement des autres
for slave in "${SLAVES[@]}"; do
  remote_run ${slave} "~/scripts/run_cassandra_local.sh"
done

