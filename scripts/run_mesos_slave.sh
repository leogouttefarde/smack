#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

MASTER=$1
sudo mesos-slave --ip=${MY_IP} --master=zk://${MASTER}:2181/mesos --work_dir=/var/lib/mesos > /dev/null 2>&1
