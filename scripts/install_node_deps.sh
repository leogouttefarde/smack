
# Ajout des repos nécessaires
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

SPARK_LINK='http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz'
SPARK_TAR="${SPARK_LINK##*/}"
SPARK_DIRECTORY_NAME=${SPARK_TAR%\.tgz*}

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

# Mise à jour du cache pour avoir accès aux nouveaux composants
sudo apt-get -y update

# Installation de mesos
sudo apt-get -y install mesos

# Installation de spark
wget -P ~ ${SPARK_LINK} &>/dev/null
tar -xzf ~/${SPARK_TAR}

# Not useful anymore, clean it
rm -f ~/${SPARK_TAR}


if [[ $# -eq 1 ]]; then
    echo 'spark.master mesos://'$1':5050'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf &> /dev/null
    printf '\nspark.executor.memory 512m'| sudo tee --append ~/${SPARK_DIRECTORY_NAME}/conf/spark-defaults.conf &> /dev/null
    echo 'export MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so'| sudo tee ~/${SPARK_DIRECTORY_NAME}/conf/spark-env.sh &> /dev/null
fi
