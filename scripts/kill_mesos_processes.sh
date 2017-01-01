#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


SELF=$(hostname)

if array_contains SLAVES ${SELF}
then
    ~/kill_mesos_local.sh
elif array_contains MASTERS ${SELF}
then
    ~/kill_mesos_local.sh im_a_master
fi
