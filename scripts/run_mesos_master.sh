#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo service zookeeper restart && sudo mesos-master --zk=zk://${MASTER}:2181/mesos --quorum=1 --ip=${MY_IP} --work_dir=/var/lib/mesos > /dev/null 2>&1
