#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


SELF=$(hostname)

if array_contains SLAVES ${SELF}
then
    ~/run_mesos_slave.sh
elif array_contains MASTERS ${SELF}
then
    ~/run_mesos_master.sh
fi

