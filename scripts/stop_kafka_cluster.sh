#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

curl "http://localhost:7000/api/broker/stop?broker=*" &>/dev/null
curl "http://localhost:7000/api/broker/remove?broker=*" &>/dev/null
sudo kill $(sudo lsof -t -i:7000) &>/dev/null