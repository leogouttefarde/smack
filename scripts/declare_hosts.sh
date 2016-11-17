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

# creates a backup of previous hosts
# and prevents multiple execution
restore_hosts()
{
  if [ -f "$HOSTS_BACKUP" ]; then
    sudo mv "$HOSTS_BACKUP" "$HOSTS"
  else
    echo "No backup of $HOSTS to restore, aborting"
    exit
  fi
}

# adds a server declaration to hosts
decl_serv()
{
  if [[ $# -ge 2 ]]; then
    local IP="$1"
    local HOST="$2"

    if [[ $(hostname) = "$HOST" ]]; then
      IP="$LOCAL_IP"
    fi

    printf "\n$IP $HOST\n" | sudo tee --append /etc/hosts &> /dev/null
  fi
}

# backup hosts
backup_hosts

# declare all servers
decl_serv 213.32.72.246 server-1
decl_serv 213.32.72.245 server-2
decl_serv 213.32.72.62 server-3
decl_serv 149.202.188.215 server-4


