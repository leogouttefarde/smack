#! /bin/bash

echo "Killing cassandra on $(hostname)"

sudo kill $(ps auwx | grep cassandra | awk '{print $2}') &>/dev/null
sudo rm -rf ~/apache-cassandra-3.9/data/* &>/dev/null

