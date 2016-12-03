# configures hosts

HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old
LOCAL_IP=127.0.1.1

# creates a backup of previous hosts
# and prevents multiple execution
backup_hosts()
{
  if ! [ -f "$HOSTS_BACKUP" ]; then
    sudo cp "$HOSTS" "$HOSTS_BACKUP"
  else
    echo "A backup of $HOSTS already exists, aborting"
    exit
  fi
}

# restores original hosts file
restore_hosts()
{
  if [ -f "$HOSTS_BACKUP" ]; then
    sudo mv "$HOSTS_BACKUP" "$HOSTS"
  else
    echo "No backup of $HOSTS to restore, aborting"
    exit
  fi
}

# adds a declaration to hosts
append_host()
{
  if [[ $# -ge 2 ]]; then
    printf "$1 $2\n" | sudo tee --append /etc/hosts &> /dev/null
  fi
}

# adds a server declaration to hosts
decl_serv()
{
  if [[ $# -ge 2 ]]; then
    local IP="$1"
    local HOST="$2"
    local NUM="${HOST##*-}"
    local NODE=node$NUM

    if [[ $(hostname) = "$HOST" ]]; then
      IP="$LOCAL_IP"
    fi

    append_host "\n$IP" $HOST
    append_host $IP $NODE
  fi
}

if [ $# -ge 1 ]; then

  restore_hosts
  echo "Hosts restauration finished"

else

  # backup hosts
  backup_hosts

  # declare all servers
  decl_serv 213.32.72.246 server-1
  decl_serv 213.32.72.245 server-2
  decl_serv 213.32.72.62 server-3
  decl_serv 149.202.188.215 server-4

  echo "Hosts installation finished"

fi;

