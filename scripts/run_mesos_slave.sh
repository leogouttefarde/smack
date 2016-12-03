#!/usr/bin/env bash

MY_IP=$(cat /etc/my_ip)
MASTER=$1
sudo mesos-slave --ip=${MY_IP} --master=${MASTER}:5050 --work_dir=/var/lib/mesos > /dev/null 2>&1 &