CP=.:kafka-clients-0.10.1.0.jar
CONSDIR=Kafka_Test_Consumer
PRODDIR=Kafka_Test_Producer

all: ${CONSDIR}/bin/TestConsumerMain.class ${PRODDIR}/bin/TestProducerMain.class

${CONSDIR}/bin/TestConsumerMain.class: ${CONSDIR}/src/TestConsumerMain.java ${CONSDIR}/src/ConsumerTest.java
	javac -cp ${CP} ${CONSDIR}/src/TestConsumerMain.java ${CONSDIR}/src/ConsumerTest.java -d ${CONSDIR}/bin

${PRODDIR}/bin/TestProducerMain.class: ${PRODDIR}/src/TestProducerMain.java ${PRODDIR}/src/ProducerTest.java
	javac -cp ${CP} ${PRODDIR}/src/TestProducerMain.java ${PRODDIR}/src/ProducerTest.java -d ${PRODDIR}/bin

clean:
	rm ${CONSDIR}/bin/*.class
	rm ${PRODDIR}/bin/*.class
