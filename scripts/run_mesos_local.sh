#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


if array_contains SLAVES ${SELF}; then

  $XNET/scripts/run_mesos_slave.sh

elif array_contains MASTERS ${SELF}; then

  $XNET/scripts/run_mesos_master.sh

fi

