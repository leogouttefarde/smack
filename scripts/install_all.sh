# global installation script that installs everything, everywhere


# runs a script remotely & asynchronously
remote_run()
{
  if [[ $# -ge 2 && -f "$2" && "$2" = *.sh ]]; then
    local SPATH=/tmp/$(basename $2)
    scp -oStrictHostKeyChecking=no -i ~/.ssh/xnet $2 xnet@$1:$SPATH

    # fixes weird var expand bug
    local CMD=$(echo "nohup sh $SPATH &> /dev/null &")
    ssh -oStrictHostKeyChecking=no -i ~/.ssh/xnet xnet@$1 "$CMD"
  fi
}


RES=~/setup.zip


# for each node
for i in {1..4}; do

  SERV=server-$i

  scp -oStrictHostKeyChecking=no -i ~/.ssh/xnet ${RES} xnet@${SERV}:~
  ssh -oStrictHostKeyChecking=no -i ~/.ssh/xnet xnet@${SERV} "unzip -o ~/setup.zip"

done


cd ~/scripts


# configure hosts
./declare_hosts.sh


# install each server
for i in {1..4}; do
  remote_run server-$i server_install.sh
done


