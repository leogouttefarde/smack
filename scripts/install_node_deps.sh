#Ajout des repos nécessaires
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list

#Mise à jour du cache pour avoir accès aux nouveaux composants
sudo apt-get -y update

#Installation de mesos
sudo apt-get -y install mesos