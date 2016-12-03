#! /bin/bash
# global installation script that installs everything, everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# install each server
for i in {1..4}; do

  remote_run server-$i ~/scripts/server_install.sh

done



