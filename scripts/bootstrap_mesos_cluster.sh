#!/bin/bash
#first node is the master
NODES=('server-1' 'server-2' 'server-3' 'server-4')

#Installation des dépendances
function install_deps {
    #Si on est entrain de configurer le master on ajoute son hostname aux arguments du script
    #Le master requiert un peu plus de config, notamment pour spark
    if [[ $1 -eq ${NODES[0]} ]]; then
    	ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./install_node_deps.sh $1 &
    else
	    ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./install_node_deps.sh &
    fi
}

function configure_mesos_master {
	ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./configure_mesos_master.sh &
}

function configure_mesos_slave {
	ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./configure_mesos_slave.sh &
}

echo "Installation des dépendances"
for node in "${NODES[@]}"
	do
		install_deps ${node}
	done

echo 'Configuration du master mesos'
configure_mesos_master ${NODES[0]}

for slave in "${NODES[@]:1}"
	do
		echo "Configuration de l'esclave mesos "${slave}
		configure_mesos_slave ${slave}
	done