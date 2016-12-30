# mmonit installation & configuration script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Installation de M/Monit sur "$SELF

# Install monit
sudo apt-get -y install monit

# Replace with version 5.2 (minimal requirement)
sudo service monit stop
sudo apt-get install monit html2text -y

MONITVER=$(wget -q https://mmonit.com/monit/dist/binary/ -O - | html2text | grep DIR | tail -n 1 | tr -d / | awk '{print $2}')
cd /tmp
wget https://mmonit.com/monit/dist/binary/$MONITVER/monit-$MONITVER-linux-x64.tar.gz
tar -xf monit-*
cd monit-*
sudo cp bin/monit /usr/bin/monit
sudo ln -s /etc/monit/monitrc /etc/monitrc
sudo cp -f /etc/monit/monitrc{,.old}

sudo service monit restart


wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz -O mmonit.tgz

tar -xzf mmonit.tgz
rm -f mmonit.tgz

~/mmonit-3.6.2/bin/mmonit



# Add services to monitor
sudo chmod go+rw /etc/monitrc


SELF=$(hostname)

# Enable mmonit on server
cat <<EOT >> /etc/monitrc
set eventqueue basedir /var/monit/ slots 1000
set mmonit http://monit:monit@$SELF:8080/collector
set httpd port 2812 and use address $SELF
allow localhost
allow $SELF
allow monit:monit

EOT


# Monitor M/Monit using Monit
cat <<EOT >> /etc/monitrc
 check process mmonit with pidfile /home/xnet/mmonit-3.6.2/logs/mmonit.pid
   start program = "/home/xnet/mmonit-3.6.2/bin/mmonit" 
   stop program = "/home/xnet/mmonit-3.6.2/bin/mmonit stop"
EOT



# Monitor Cassandra
cat <<EOT >> /etc/monitrc
 check process cassandra with pidfile $PIDF_CASSANDRA
     start program = "/home/xnet/scripts/run_cassandra_local.sh"
     stop program  = "/home/xnet/scripts/kill_cassandra_processes.sh"
EOT



# TODO : Add other services here
# WARNING : any script loaded here containing ~ will point to /root NOT /home/xnet !!



# Reload monit configuration
sudo chmod 600 /etc/monitrc
sudo monit reload


