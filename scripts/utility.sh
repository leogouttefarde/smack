
RES=https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip
SSH_OPTS="-q -oStrictHostKeyChecking=no -i ~/.ssh/xnet"
SILENT="&>/dev/null"
MARKER=/etc/smack_installed

IP_FILE=/etc/my_ip
HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old
LOCAL_IP=127.0.1.1
MY_IP=$(cat $IP_FILE)


# Runs a remote command (asynchronous)
# Usage : remote_run <server> <cmd>
remote_run()
{
  if [[ $# -ge 2 ]]; then
    ssh ${SSH_OPTS} xnet@$1 "$2" &
  fi
}

# Runs a remote command (synchrone)
# Usage : remote_run_sync <server> <cmd>
remote_run_sync()
{
  if [[ $# -ge 2 ]]; then
    ssh ${SSH_OPTS} xnet@$1 "$2"
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

finish_server_install()
{
  echo installed | sudo tee $MARKER &>/dev/null
}

finish_server_uninstall()
{
  sudo rm -f $MARKER
}

setup_res()
{
  cd ~

  ZIP=~/setup.zip

  # configure hosts
  ~/scripts/declare_hosts.sh

  # Refresh raw file ? Seems required for updates
  curl -s https://github.com/leogouttefarde/smack/blob/master/setup.zip?raw=true &>/dev/null
  curl -s https://github.com/leogouttefarde/smack/raw/master/setup.zip &>/dev/null

  # for each node
  for i in {1..4}; do

    SERV=server-$i
 
    echo "Updating setup on $SERV"

    CMD="wget --no-cache -O ${ZIP} ${RES} ${SILENT}; unzip -o ${ZIP} ${SILENT}; ~/scripts/version.sh"
    remote_run_sync $SERV "${CMD}"

  done

  cd ~/scripts
}

# Tells if the server was already installed
is_installed()
{
  if [[ -f $HOSTS_BACKUP && -f $MARKER ]]; then

    # 0 for success
    return 0
  fi

  # failure
  return -1
}

# Checks if the server was already installed
# Exits with a message if it was
check_installed()
{
  # Abort if already installed
  if is_installed ; then

    echo "This server is already installed, aborting"
    exit

  fi
}


# First node is the master
NODES=('server-1' 'server-2' 'server-3' 'server-4')
SLAVES=${NODES[@]:1}
MASTER='server-1'

#Installation des dépendances
install_deps()
{
    remote_run_sync $1 ~/scripts/install_node_deps.sh
}
