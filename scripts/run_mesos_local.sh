#!/usr/bin/env bash

SELF=$(hostname)

if array_contains SLAVES ${SELF}
then
    ~/run_mesos_slave.sh
elif array_contains MASTERS ${SELF}
then
    ~/run_mesos_master.sh
fi