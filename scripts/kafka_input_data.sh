#!/bin/bash


##### Warning:The argument of this script must be the path of the folder containing all the dataset

##### install kafkaCat to produce and retrieve message

sudo apt-get install kafkacat

##### import the name of the topic and the broker

source ./add_kafka_topic.sh

##### Get all the dataset files

if [[ "$1" != "" ]];

then

	if [[ "$BROKER" == ""]] || [["$TOPIC_NAME" == ""]];
	then
		./add_kafka_topic.sh                                                                                               # to define a new topic if no topic exists  
	fi


	INPUTFOLDER=$1;
	
	FILE_ARRAY="$(ls $INPUTFOLDER)"
	
	NUMBER_FILES=${#FILE_ARRAY[@]}

	COUNT=0;

	for FILE in "${FILE_ARRAY[@]}";
		do	
			
			remote_run_sync ${MASTER} " cat $INPUTFOLDER/$FILE|kafkacat -P --broker $BROKER: 3000 --topic $TOPIC_NAME"
			COUNT=$((COUNT + 1))

			if [["$COUNT" -ne "$FILE_ARRAY" ]];
			
			then
	
				remote_run_sync ${MASTER} " echo #####NewFile#####|kafkacat -P --broker $BROKER: 3000 --topic $TOPIC_NAME" # will be used to separate the differents files after
			fi

		done

else
	echo "Arguments missing..."

fi
	

