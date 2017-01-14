package producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.Scanner;


public class MyProducer {

    private String filePath;
    private String topic;

    public MyProducer(String filePath, String topic) {
        this.filePath = filePath;
        this.topic = topic;
    }

    void produce() throws IOException {
        Properties props = new Properties();
        props.put("bootstrap.servers", "server-2:31000,server-3:31000");
        props.put("acks", "all");
        props.put("retries", 0);
        props.put("batch.size", 16384);
        props.put("linger.ms", 1);
        props.put("buffer.memory", 33554432);
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        Producer<String, String> producer = new KafkaProducer<>(props);

        Scanner fileScanner = new Scanner(new FileInputStream(filePath));

        int lineIndex = 0;

        while (fileScanner.hasNext()) {
            String message = fileScanner.nextLine();
            producer.send(new ProducerRecord<>(topic, Integer.toString(lineIndex++), message));
        }

        producer.close();
    }
}
