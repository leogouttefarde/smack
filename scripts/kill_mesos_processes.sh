#!/usr/bin/env bash

SELF=$(hostname)

if array_contains SLAVES ${SELF}
then
    ~/kill_mesos_local.sh
elif array_contains MASTERS ${SELF}
then
    ~/kill_mesos_local.sh im_a_master
fi