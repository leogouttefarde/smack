# global installation script that installs everything, everywhere

# runs a script remotely
remote_run()
{
  if [[ $# -ge 2 && -f "$2" && "$2" = *.sh ]]; then
    ssh -oStrictHostKeyChecking=no -i ~/.ssh/xnet xnet@$1 'bash -s' < "$2"
  fi
}


# configure hosts
./declare_hosts.sh


# install each server
for i in {1..4}; do
  remote_run server-$i server_install.sh
done


