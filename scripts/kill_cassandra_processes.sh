#! /bin/bash

sudo pkill -f 'java.*cassandra' &>/dev/null
#sudo kill $(ps auwx | grep cassandra | awk '{print $2}') &>/dev/null
sudo rm -rf ~/apache-cassandra-3.9/data/* &>/dev/null


echo "Cassandra killed on $(hostname)"

