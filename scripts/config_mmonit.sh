# mmonit installation & configuration script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Configuration de M/Monit sur "$SELF


# Lancement de M/Monit
#~/mmonit-3.6.2/bin/mmonit


# Add services to monitor
sudo chmod go+rw /etc/monitrc


# Enable mmonit on server
cat <<EOT >> /etc/monitrc
set eventqueue basedir /var/monit/ slots 1000
set mmonit http://monit:monit@$(host2ip server-1):8080/collector
set mmonit http://monit:monit@$(host2ip server-2):8080/collector
set mmonit http://monit:monit@$(host2ip server-3):8080/collector
set mmonit http://monit:monit@$(host2ip server-4):8080/collector
set mmonit http://monit:monit@$(host2ip server-5):8080/collector
set mmonit http://monit:monit@$(host2ip server-6):8080/collector
set httpd port 2812
use address $MY_IP
allow localhost
allow $(host2ip server-1)
allow $(host2ip server-2)
allow $(host2ip server-3)
allow $(host2ip server-4)
allow $(host2ip server-5)
allow $(host2ip server-6)
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


# Restauration droits fichier
sudo chmod 600 /etc/monitrc

# Reload monit configuration
sudo monit reload


