#! /bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

sudo kill $(cat $PIDF_CASSANDRA)

#sudo pkill -f 'java.*cassandra' &>/dev/null
#sudo kill $(ps auwx | grep cassandra | awk '{print $2}') &>/dev/null

# Clean Cassandra data
sudo rm -rf ~/apache-cassandra-3.9/data/* &>/dev/null


echo "Cassandra killed on $(hostname)"

