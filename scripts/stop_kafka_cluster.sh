#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


for MASTER in ${MASTERS};do

    remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/stop?broker=*" &>/dev/null'
    remote_run_sync ${MASTER} 'curl "http://'${MASTER}':7000/api/broker/remove?broker=*" &>/dev/null'
    remote_run_sync ${MASTER} 'sudo kill $(sudo lsof -t -i:7000) &>/dev/null'

done
