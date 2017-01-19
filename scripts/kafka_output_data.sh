#!/bin/bash


##### Warning:The argument of this script must be the path of a file that will contained all the data processed by kafka


##### import the name of the topic and the broker
source ./add_kafka_topic.sh


if [[ "$1" != "" ]];
then
	OUTPUTFILE=$1

	if [[ "$BROKER" == ""]] || [["$TOPIC_NAME" == ""]];
	then
		./add_kafka_topic.sh                                                                       # to define a new topic if no topic exists

		./kafka_input_data.sh                                                                      # to get the input data
	fi

 
	remote_run_sync ${MASTER} "kafkacat -C --broker $BROKER:3000 --topic $TOPIC_NAME >> $OUTPUTFILE"   # all the data will be stored in one big file

	NUMBER_MESSAGE="$(grep -n #####Message##### $OUTPUTFILE | wc -l)"                                  # NUMBER_MESSAGE contains the number of differents files that have been processed    

	if [[ $NUMBER_MESSAGE -gt 1 ]];
	
	then
		sed 's/#####NewFile#####/\n&/2g' $OUTPUTFILE | split -dl1 - DATASET                        # split the big file into small ones DATASET00, DATASET01, ...

	mkdir -p DatasetFolder
	
	mv DATASET* DatasetFolder
	
	fi

else

	echo "Arguments missing..."

fi
