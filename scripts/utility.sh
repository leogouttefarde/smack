
XNET=/home/xnet
RES=https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip
SSH_OPTS="-q -oStrictHostKeyChecking=no -i ~/.ssh/xnet"
SILENT="&>/dev/null"
MARKER=/etc/smack_installed

IP_FILE=/etc/my_ip
HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old
LOCAL_IP=127.0.1.1
MY_IP=$(cat $IP_FILE 2>/dev/null)
SELF=$(hostname)

# First node is the master
NODES=('server-1' 'server-2' 'server-3' 'server-4' 'server-5' 'server-6')
SLAVES=('server-2' 'server-3')
MASTERS=('server-4' 'server-5' 'server-6')
MANAGER='server-1'

function join_by { local IFS="$1"; shift; echo "$*"; }

array_contains () {
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

MASTERS_WITH_ZK_PORT=("${MASTERS[@]/%/:2181}")
JOINED_MASTERS_WITH_ZK_PORT=$(join_by , ${MASTERS_WITH_ZK_PORT[@]})

PIDF_CASSANDRA=$XNET/apache-cassandra-3.9/cassandra.pid
PIDF_MESOS=$XNET/mesos.pid
PIDF_KAFKA_SCHEDULER=$XNET/kafka_scheduler.pid

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

host2ip()
{
  if [[ $# -ge 1 ]]; then
    IP=$(getent hosts $1 | cut -d' ' -f1)
    echo $IP
  fi
}

slaves_list()
{
  local out=$(printf ",%s" ${SLAVES[@]})
  out="${out:1}"

  echo "${out}"
}

run_cmd_all()
{
  if [[ $# -ge 1 ]]; then

    # for each node
    for SERV in "${NODES[@]}"; do

      echo "Running command on $SERV"
      remote_run $SERV "$1"

    done

  fi
}

command_exists()
{
  type "$1" &> /dev/null;
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

  FUNC='command_exists() { type "$1" &> /dev/null; }'
  WGET="wget --no-cache -O ${ZIP} ${RES} ${SILENT}"
  INSTALL="if ! command_exists unzip ; then sudo apt -y install unzip ${SILENT}; fi"
  UNZIP="unzip -o ${ZIP} ${SILENT}"

  CMD="${FUNC}; ${WGET}; ${INSTALL}; ${UNZIP}; ~/scripts/version.sh"

  # for each node
  for SERV in "${NODES[@]}"; do

    echo "Updating setup on $SERV"

    remote_run_sync $SERV "${CMD}"

  done

  cd ~/scripts
}

# Tells if the server was already installed
is_installed()
{
  if [[ -f $MARKER ]]; then

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


