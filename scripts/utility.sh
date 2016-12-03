
SSH_OPTS="-oStrictHostKeyChecking=no -i ~/.ssh/xnet"
RES=https://raw.githubusercontent.com/leogouttefarde/smack/master/setup.zip
SILENT="&>/dev/null"

# Runs a script remotely & asynchronously.
# Usage : remote_run <server> <script>
# Scripts must have the .sh extension
remote_run()
{
  if [[ $# -ge 2 && -f "$2" && "$2" = *.sh ]]; then
    local SPATH=/tmp/$(basename $2)
    scp ${SSH_OPTS} $2 xnet@$1:$SPATH ${SILENT}

    # fixes weird var expand bug
    local CMD=$(echo "nohup sh $SPATH &> /dev/null &")
    ssh ${SSH_OPTS} xnet@$1 "${CMD}"
  fi
}

setup_res()
{
  cd ~

  ZIP=~/setup.zip

  # configure hosts
  ~/scripts/declare_hosts.sh

  # for each node
  for i in {1..4}; do

    SERV=server-$i

    ssh ${SSH_OPTS} xnet@${SERV} "wget -O ${ZIP} ${RES} ${SILENT}; unzip -o ${ZIP} ${SILENT}"

  done

  cd ~/scripts
}

