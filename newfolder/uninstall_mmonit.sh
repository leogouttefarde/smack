# mmonit uninstallation script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


~/mmonit-3.6.2/bin/mmonit stop

sudo service monit stop


# restore default monit config
sudo mv /etc/monit/monitrc{.old,}

sudo apt-get -y remove monit html2text

sudo rm -rf ~/mmonit-3.6.2
sudo rm -f ~/mmonit.tgz /etc/monitrc
sudo rm -f /usr/bin/monit /var/log/monit.log

