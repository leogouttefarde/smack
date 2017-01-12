#!/bin/bash


##### Warning:The argument of this script must be the path of the folder containing all the dataset

##### install kafkaCat to produce and retrieve message

sudo apt-get install kafkacat

##### import the name of the topic and the broker

source kafka-retrieveData.sh

##### Get all the dataset files

if [[ "$1" != "" ]];

then

	INPUTFOLDER=$1;

	mkdir -p newfolder;

	for FILE in `ls $INPUTFOLDER`
		do	
			
			remote_run_sync ${MASTER} " cat $INPUTFOLDER/$FILE|kafkacat -P --broker $BROKER: 3000 --topic $TOPIC_NAME"
	
			remote_run_sync ${MASTER} " echo #####Message#####|kafkacat -P --broker $BROKER: 3000 --topic $TOPIC_NAME" # will be used to separate the differents files after

		done

else
	echo "Arguments missing..."

fi
	

