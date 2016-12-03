
RES=https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip
SSH_OPTS="-oStrictHostKeyChecking=no -i ~/.ssh/xnet"
SILENT="&>/dev/null"

IP_FILE=/etc/my_ip
HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old
LOCAL_IP=127.0.1.1
MY_IP=$(cat $IP_FILE)

# Runs a remote command (asynchronous)
# Usage : remote_run <server> <script>
remote_run()
{
  if [[ $# -ge 2 ]]; then
    ssh -q ${SSH_OPTS} xnet@$1 "$2" &
  fi
}

# Sends a script, then runs it remotely (asynchronous)
# Usage : remote_run <server> <script>
# Scripts must have the .sh extension
send_run()
{
  if [[ $# -ge 2 && -f "$2" && "$2" = *.sh ]]; then
    local SPATH=/tmp/$(basename $2)
    scp ${SSH_OPTS} $2 xnet@$1:$SPATH &>/dev/null

    # fixes weird var expand bug
    local CMD=$(echo "nohup bash $SPATH &> /dev/null &")
    remote_run $SERV "${CMD}"
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
    remote_run $SERV "${CMD}"

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


# First node is the master
NODES=('server-1' 'server-2' 'server-3' 'server-4')
SLAVES=${NODES[@]:1}
MASTER='server-1'

#Installation des dépendances
install_deps()
{
  #Si on est entrain de configurer le master on ajoute son hostname aux arguments du script
  #Le master requiert un peu plus de config, notamment pour spark
  if [[ $1 -eq $MASTER ]]; then
    remote_run $1 ~/scripts/install_node_deps.sh $1
  else
    remote_run $1 ~/scripts/install_node_deps.sh
  fi
}

configure_mesos_master()
{
  if [[ $# -ge 2 ]]; then
    remote_run $1 ~/scripts/configure_mesos_master.sh
  fi
}

configure_mesos_slave()
{
  if [[ $# -ge 2 ]]; then
    remote_run $1 ~/scripts/configure_mesos_slave.sh
  fi
}

