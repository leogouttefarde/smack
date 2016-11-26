#!/bin/bash
MASTER='server-1'
SLAVES=('server-2' 'server-3' 'server-4')


function install_deps {
	ssh -q -i ~/.ssh/xnet $1 "bash -s" < ./install_node_deps.sh
}

function configure_master {
	ssh -q -i ~/.ssh/xnet $1 "bash -s" < ./configure_mesos_master.sh
}

function configure_slave {
	ssh -q -i ~/.ssh/xnet $1 "bash -s" < ./configure_mesos_slave.sh
}

echo 'Installation des dépendances pour le master'
install_deps ${MASTER}

for slave in "${SLAVES[@]}"
	do
		echo "Installation des dépendances pour l'esclave "${slave}
		install_deps ${slave}
	done

echo 'Configuration du master'
configure_master ${MASTER}

for slave in "${SLAVES[@]}"
	do
		echo "Configuration de l'esclave "${slave}
		configure_slave ${slave}
	done