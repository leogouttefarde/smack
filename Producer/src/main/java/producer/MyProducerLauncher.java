package producer;

import java.io.IOException;

public class MyProducerLauncher {
    public static void main(String[] args) throws IOException {
        if (args.length < 2) {
            System.out.println("Not enough arguments provided");
            System.exit(-1);
        }
        String filePath = args[0];
        String topic = args[1];
        MyProducer producer = new MyProducer(filePath, topic);
        producer.produce();
    }
}
