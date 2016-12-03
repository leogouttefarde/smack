
RES=https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip
SSH_OPTS="-oStrictHostKeyChecking=no -i ~/.ssh/xnet"
SILENT="&>/dev/null"

HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old
LOCAL_IP=127.0.1.1

# Runs a script remotely & asynchronously.
# Usage : remote_run <server> <script>
# Scripts must have the .sh extension
remote_run()
{
  if [[ $# -ge 2 && -f "$2" && "$2" = *.sh ]]; then
    local SPATH=/tmp/$(basename $2)
    scp ${SSH_OPTS} $2 xnet@$1:$SPATH &>/dev/null

    # fixes weird var expand bug
    local CMD=$(echo "nohup sh $SPATH &> /dev/null &")
    ssh ${SSH_OPTS} xnet@$1 "${CMD}"
  fi
}

setup_res()
{
  echo "Preparing setup"

  cd ~

  ZIP=~/setup.zip

  # configure hosts
  ~/scripts/declare_hosts.sh

  # for each node
  for i in {1..4}; do

    SERV=server-$i

    CMD="wget --no-cache -O ${ZIP} ${RES} ${SILENT}; unzip -o ${ZIP} ${SILENT}"
    ssh ${SSH_OPTS} xnet@${SERV} "${CMD}"

  done

  cd ~/scripts
}

# Checks if the server was already installed
is_installed()
{
  if [ -f "$HOSTS_BACKUP" ]; then

    # 0 for success
    return 0
  fi

  # failure
  return -1
}


# first node is the master
NODES=('server-1' 'server-2' 'server-3' 'server-4')

#Installation des dépendances
function install_deps {
    #Si on est entrain de configurer le master on ajoute son hostname aux arguments du script
    #Le master requiert un peu plus de config, notamment pour spark
    if [[ $1 -eq ${NODES[0]} ]]; then
      ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./install_node_deps.sh $1
    else
      ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./install_node_deps.sh
    fi
}

function configure_mesos_master {
  ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./configure_mesos_master.sh &
}

function configure_mesos_slave {
  ssh -q -i ~/.ssh/xnet $1 "bash -s > /dev/null 2>&1" < ./configure_mesos_slave.sh &
}

