#! /bin/bash
# global installation script that installs everything, everywhere

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


setup_res

# install each server
for i in {1..4}; do

  SERV=server-$i

  echo "Installing $SERV"
  remote_run $SERV ~/scripts/server_install.sh

done


echo 'Configuration du master mesos'
configure_mesos_master ${NODES[0]}

for slave in "${NODES[@]:1}"
	do
		echo "Configuration de l'esclave mesos "${slave}
		configure_mesos_slave ${slave}
	done

