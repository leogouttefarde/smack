#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

MASTER=$1
sudo mesos-slave --ip=${MY_IP} --master=${MASTER}:5050 --work_dir=/var/lib/mesos > /dev/null 2>&1
