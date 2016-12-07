#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


# Lancement du seeder cassandra
remote_run_sync ${MASTER} "~/scripts/run_cassandra.sh"


# Lancement des autres
for slave in ${SLAVES}; do
  remote_run ${slave} "~/scripts/run_cassandra.sh"
done

