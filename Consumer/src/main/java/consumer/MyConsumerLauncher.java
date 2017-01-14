package consumer;

import java.util.Arrays;
import java.util.List;

public class MyConsumerLauncher {
    private static final List<String> SEEDS = Arrays.asList("server-2", "server-3");
    private static final int PORT = 31000;

    public static void main(String args[]) {
        if (args.length < 3) {
            System.out.println("Not enough arguments provided");
            System.exit(-1);
        }
        MyConsumer consumer = new MyConsumer();
        long maxReads = Long.parseLong(args[0]);
        String topic = args[1];
        int partition = Integer.parseInt(args[2]);
        try {
            consumer.run(maxReads, topic, partition, SEEDS, PORT);
        } catch (Exception e) {
            System.out.println("Oops:" + e);
            e.printStackTrace();
        }
    }
}
