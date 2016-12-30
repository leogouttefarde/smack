#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


for node in "${NODES[@]}"; do
  remote_run ${node} '~/scripts/kill_cassandra_processes.sh'
done

