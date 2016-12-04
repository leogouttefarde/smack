DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

# Ajout des repos nécessaires
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

SPARK_LINK='http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz'
SPARK_TAR="${SPARK_LINK##*/}"
SPARK_DIRECTORY_NAME=${SPARK_TAR%\.tgz*}

KAFKA_LINK='https://archive.apache.org/dist/kafka/0.8.2.2/kafka_2.10-0.8.2.2.tgz'

SELF=$(hostname)

echo 'Installation clé E56151BF sur $SELF'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list


echo 'Mise à jour du cache sur $SELF'

# Mise à jour du cache pour avoir accès aux nouveaux composants
sudo apt-get -y update


echo 'Installation de mesos sur $SELF'
sudo apt-get -y install mesos

echo 'Installation de spark sur $SELF'
wget -P ~ ${SPARK_LINK} 2>/dev/null
tar -xzf ~/${SPARK_TAR}

# Not useful anymore, clean it
rm -f ~/${SPARK_TAR}

if [[ ${SELF} = ${MASTER} ]]; then

  echo 'Serveur maître détecté'

  echo 'spark.master mesos://zk://'${MASTER}':2181/mesos'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf
  printf '\nspark.executor.memory 512m'| sudo tee --append ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf
  echo 'export MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-env.sh


  echo 'Installation de Kafka'

  #Installation de Kafka (seulement au niveau du master)
  sudo apt -y install openjdk-8-jdk
  git clone https://github.com/mesos/kafka
  cd kafka && ./gradlew jar
  wget -P ~/kafka ${KAFKA_LINK} 2>/dev/null

  export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
  export LIBPROCESS_IP=$(cat /etc/my_ip)


  echo 'Configuration de Kafka'

  printf '\nuser=xnet'| sudo tee ~/kafka/kafka-mesos.properties
  printf '\nzk='${SELF}':2181'| sudo tee --append ~/kafka/kafka-mesos.properties
  printf '\nstorage=zk:/mesos-kafka-scheduler'| sudo tee --append ~/kafka/kafka-mesos.properties
  printf '\nmaster=zk://'${MASTER}':2181/mesos'| sudo tee --append ~/kafka/kafka-mesos.properties
  printf '\napi=http://'${MASTER}':7000'| sudo tee --append ~/kafka/kafka-mesos.properties

  echo 'Fin du bloc maître'

fi


echo 'Installation de Scala sur $SELF'
sudo apt-get -y install scala


echo 'Installation des dépendances terminée sur $SELF'

