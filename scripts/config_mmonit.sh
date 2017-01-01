# mmonit installation & configuration script

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh


echo "Configuration de M/Monit sur "$SELF

# Now using systemd
#~/mmonit-3.6.2/bin/mmonit

# Auto startup using systemd
sudo rm -f /etc/systemd/system/mmonit.service
sudo touch /etc/systemd/system/mmonit.service
sudo chmod 666 /etc/systemd/system/mmonit.service
cat <<EOT > /etc/systemd/system/mmonit.service
[Unit]
Description = Easy, proactive monitoring of Unix systems, network and cloud services
After = network.target

[Service]
Type=simple
ExecStart = $XNET/mmonit-3.6.2/bin/mmonit -i
ExecStop = $XNET/mmonit-3.6.2/bin/mmonit stop
PIDFile = $XNET/mmonit-3.6.2/logs/mmonit.pid
Restart = on-abnormal

[Install]
WantedBy = multi-user.target
EOT
sudo chmod 644 /etc/systemd/system/mmonit.service

# Reload systemd configuration, enable M/Monit on boot and start it
sudo systemctl daemon-reload
sudo systemctl enable mmonit
sudo systemctl start mmonit


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


# Now using systemd
# # Auto startup using Monit
# # Monitor M/Monit using Monit
# cat <<EOT >> /etc/monitrc
#  check process mmonit with pidfile $XNET/mmonit-3.6.2/logs/mmonit.pid
#    start program = "$XNET/mmonit-3.6.2/bin/mmonit -p $XNET/mmonit-3.6.2/logs" 
#    stop program = "$XNET/mmonit-3.6.2/bin/mmonit stop"
# EOT



# Monitor Cassandra
cat <<EOT >> /etc/monitrc
 check process cassandra with pidfile $PIDF_CASSANDRA
     start program = "$XNET/scripts/run_cassandra_local.sh replace rdm"
     stop program  = "$XNET/scripts/kill_cassandra_processes.sh"
EOT



# TODO : Add other services here
# WARNING : any script loaded here containing ~ will point to /root NOT /home/xnet !!

# Use monit for mesos except on the manager
if [[ $SELF != "$MANAGER" ]]; then
cat <<EOT >> /etc/monitrc
 check process mesos matching "^mesos/*"
     start program = "$XNET/scripts/run_mesos_local.sh"
     stop program  = "$XNET/scripts/kill_mesos_processes.sh"
EOT
fi


# Restauration droits fichier
sudo chmod 600 /etc/monitrc

# Reload monit configuration
sudo monit reload


