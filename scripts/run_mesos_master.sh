#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo service zookeeper restart && sudo mesos-master --zk=zk://${JOINED_MASTERS_WITH_ZK_PORT}/mesos --quorum=2 --ip=${MY_IP} --hostname=${MY_IP} --work_dir=/var/lib/mesos --log_dir=/var/log/mesos > /dev/null 2>&1 &

#TODO: this gives enough time for process to start before writing it to pid_file, need to look for a better solution
#sleep 5
#
#sudo lsof -t -i:5050 | sudo tee $PIDF_MESOS
