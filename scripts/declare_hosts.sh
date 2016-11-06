# configures hosts

HOSTS=/etc/hosts
HOSTS_BACKUP=$HOSTS.old

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

# adds a server declaration to hosts
decl_serv()
{
  if [[ $# -ge 2 && $(hostname) -ne "$2" ]]; then
    printf "\n$1 $2\n" | sudo tee --append /etc/hosts &> /dev/null
  fi
}

# backup hosts
backup_hosts

# declare all servers
decl_serv 213.32.72.246 server-1
decl_serv 213.32.72.245 server-2
decl_serv 213.32.72.62 server-3


