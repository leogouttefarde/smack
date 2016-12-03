#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo mesos-master --ip=${MY_IP} --work_dir=/var/lib/mesos
