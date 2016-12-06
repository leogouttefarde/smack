
# Installation de PYTHON


cd ~/
sudo apt-get -y install build-essential checkinstall
sudo apt-get -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
cd /usr/src
wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
tar xzf Python-2.7.12.tgz
cd Python-2.7.12
sudo ./configure
sudo make altinstall


# Installation de JAVA


cd ~/ 
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer


# Installation de CASSANDRA


CASSANDRA_LINK='http://apache.crihan.fr/dist/cassandra/3.9/apache-cassandra-3.9-bin.tar.gz'
CASSANDRA_TAR="${CASSANDRA_LINK##*/}"
CASSANDRA_DIRECTORY_NAME=${CASSANDRA_TAR%\-bin.tar.gz*}


echo "Installation de cassandra sur $SELF"


wget -P ~ ${CASSANDRA_LINK} 2>/dev/null
tar -xzf ~/${CASSANDRA_TAR}


cd ~/${CASSANDRA_DIRECTORY_NAME}/bin/


./cassandra -f > /dev/null 2>&1 &  


rm -f ~/${CASSANDRA_TAR}
