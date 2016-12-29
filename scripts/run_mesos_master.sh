#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo service zookeeper restart && sudo mesos-master --zk=zk://${JOINED_MASTERS_WITH_ZK_PORT}/mesos --quorum=3 --ip=${MY_IP} --work_dir=/var/lib/mesos > /dev/null 2>&1
