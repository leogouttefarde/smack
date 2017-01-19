# mmonit installation & configuration script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Installation de M/Monit sur "$SELF

# Install monit 5.2 (minimal requirement)
sudo service monit stop
sudo apt-get install monit html2text -y

MONITVER=$(wget -q https://mmonit.com/monit/dist/binary/ -O - | html2text | grep DIR | tail -n 1 | tr -d / | awk '{print $2}')
 cd /tmp && wget https://mmonit.com/monit/dist/binary/$MONITVER/monit-$MONITVER-linux-x64.tar.gz 2>/dev/null && tar -xf monit-*.tar.gz && rm -f monit-*.tar.gz && cd monit-* && sudo rm -f /usr/bin/monit && sudo cp -f bin/monit /usr/bin/moni && sudo ln -s /etc/monit/monitrc /etc/monitrc && sudo cp -f /etc/monit/monitrc{,.old} && sudo service monit restart && cd ~ && wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz -O mmonit.tgz 2>/dev/null && tar -xzf mmonit.tgz && rm -f mmonit.tgz