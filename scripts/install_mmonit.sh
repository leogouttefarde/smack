#!/usr/bin/env bash

sudo apt-get install monit

wget https://mmonit.com/dist/mmonit-3.6.2-linux-x64.tar.gz

tar -xf mmonit-3.6.2-linux-x64.tar.gz

sudo ln -s /etc/monit/monitrc /etc/monitrc
sudo cp -f /etc/monit/monitrc /etc/monit/monitrc.old

rm mmonit-3.6.2-linux-x64.tar.gz

sudo monit

sudo ./mmonit-3.6.2/bin/mmonit