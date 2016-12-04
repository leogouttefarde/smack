DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utility.sh

# Ajout des repos nécessaires
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

SPARK_LINK='http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz'
SPARK_TAR="${SPARK_LINK##*/}"
SPARK_DIRECTORY_NAME=${SPARK_TAR%\.tgz*}

KAFKA_LINK='https://archive.apache.org/dist/kafka/0.8.2.2/kafka_2.10-0.8.2.2.tgz'

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

# Mise à jour du cache pour avoir accès aux nouveaux composants
sudo apt-get -y update

# Installation de mesos
sudo apt-get -y install mesos

# Installation de spark
wget -P ~ ${SPARK_LINK}
tar -xzf ~/${SPARK_TAR}

# Not useful anymore, clean it
rm -f ~/${SPARK_TAR}

SELF=$(hostname)

if [[ ${SELF} = ${MASTER} ]]; then
    echo 'spark.master mesos://zk://'$1':2181/mesos'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf &> /dev/null
    printf '\nspark.executor.memory 512m'| sudo tee --append ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf &> /dev/null
    echo 'export MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-env.sh &> /dev/null

    #Installation de Kafka (seulement au niveau du master)
    sudo apt -y install openjdk-8-jdk
    git clone https://github.com/mesos/kafka
    ./kafka/gradlew jar
    wget -P ~/kafka ${KAFKA_LINK}
    export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
    export LIBPROCESS_IP=$(cat /etc/my_ip)

    printf '\nuser=xnet'| sudo tee --append ~/kafka/kafka-mesos.properties &> /dev/null
    printf '\nstorage=zk:/mesos-kafka-scheduler'| sudo tee --append ~/kafka/kafka-mesos.properties &> /dev/null
    printf '\nmaster=zk://'$1':2181/mesos'| sudo tee --append ~/kafka/kafka-mesos.properties &> /dev/null
    printf '\napi=http://'$1':7000'| sudo tee --append ~/kafka/kafka-mesos.properties &> /dev/null

fi


# Install Scala
sudo apt-get -y install scala


