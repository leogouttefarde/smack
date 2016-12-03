#!/usr/bin/env bash

MY_IP=$(cat /etc/my_ip)
sudo mesos-master --ip=${MY_IP} --work_dir=/var/lib/mesos > /dev/null 2>&1