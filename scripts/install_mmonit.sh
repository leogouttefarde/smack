# mmonit installation & configuration script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Installation de M/Monit sur "$SELF

# Install monit 5.2 (minimal requirement)
sudo service monit stop
sudo apt-get install monit html2text -y

#MONITVER=$(wget -q https://mmonit.com/monit/dist/binary/ -O - | html2text | grep DIR | tail -n 1 | tr -d / | awk '{print $2}')
MONITVER=5.20.0
cd /tmp
sudo wget https://mmonit.com/monit/dist/binary/$MONITVER/monit-$MONITVER-linux-x64.tar.gz -O monit.tgz 2>/dev/null
sudo tar -xf monit.tgz
sudo rm -f monit.tgz
cd monit-$MONITVER
sudo rm -f /usr/bin/monit
sudo cp -f bin/monit /usr/bin/monit
sudo ln -s /etc/monit/monitrc /etc/monitrc
sudo chmod 600 /etc/monitrc
sudo cp -f /etc/monit/monitrc{,.old}

sudo service monit restart


cd ~

wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz -O mmonit.tgz 2>/dev/null

tar -xzf mmonit.tgz
rm -f mmonit.tgz


