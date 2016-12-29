#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo mesos-slave --ip=${MY_IP} --master=zk://${JOINED_MASTERS_WITH_ZK_PORT}/mesos --work_dir=/var/lib/mesos > /dev/null 2>&1
