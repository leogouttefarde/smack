CP=.:kafka-clients-0.10.1.0.jar
CONSDIR=Kafka_Test_Consumer
PRODDIR=Kafka_Test_Producer
ZIPDIR=KafkaTest

all: ${CONSDIR}/bin/TestConsumerMain.class ${CONSDIR}/bin/ConsumerTest.class ${PRODDIR}/bin/TestProducerMain.class ${PRODDIR}/bin/ProducerTest.class
	cp ${CONSDIR}/bin/* ${ZIPDIR}/
	cp ${PRODDIR}/bin/* ${ZIPDIR}/
	cp kafka-topics.sh ${ZIPDIR}/
	zip -r kafka_test.zip ${ZIPDIR}/

${CONSDIR}/bin/TestConsumerMain.class: ${CONSDIR}/src/TestConsumerMain.java ${CONSDIR}/src/ConsumerTest.java
	javac -cp ${CP} ${CONSDIR}/src/TestConsumerMain.java ${CONSDIR}/src/ConsumerTest.java -d ${CONSDIR}/bin

${PRODDIR}/bin/TestProducerMain.class: ${PRODDIR}/src/TestProducerMain.java ${PRODDIR}/src/ProducerTest.java
	javac -cp ${CP} ${PRODDIR}/src/TestProducerMain.java ${PRODDIR}/src/ProducerTest.java -d ${PRODDIR}/bin

clean:
	rm ${CONSDIR}/bin/*.class
	rm ${PRODDIR}/bin/*.class
	rm ${ZIPDIR}/*
	rm kafka_test.zip
