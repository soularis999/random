package com.testkafka.kafka;

import com.testkafka.trackers.PartitionToKeyToCountTracker;
import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class KafkaPublisher {

    private final static String TOPIC = "process.topic";

    private static int numThreads = 0;

    private static final PartitionToKeyToCountTracker tracker = new PartitionToKeyToCountTracker(true);

    public static void main(String[] args) throws InterruptedException {
        String bootstrap = args[0];
        int threadCount = Integer.parseInt(args[1]);
        int time = 1000;
        if (args.length > 2) {
            time = Integer.parseInt(args[2]);
        }
        int num = -1;
        if (args.length > 3) {
            num = Integer.parseInt(args[3]);
        }

        KafkaPublisher example = new KafkaPublisher();
        Executor executor = Executors.newFixedThreadPool(threadCount, r -> {
            numThreads++;
            return new Thread(r, "Thread" + numThreads);
        });

        example.run(bootstrap, executor, threadCount, time, num);

        // blocking
        PartitionToKeyToCountTracker.print(tracker);
    }

    private void run(final String bootstrap, final Executor executor, final int threadCount, final int time, int numElementsToPublish) {
        for (int i = 0; i < threadCount; i++) {
            executor.execute(() -> {
                System.out.println("Starting process: " + Thread.currentThread().getName());
                try (Producer<String, String> producer = createProducer(bootstrap)) {
                    int counter = 0;
                    while (true) {
                        String key = String.valueOf(System.nanoTime() % 8);
                        ProducerRecord<String, String> record = new ProducerRecord<>(TOPIC, key,
                                "Time: " + System.nanoTime());
                        Future<RecordMetadata> future = producer.send(record);

                        RecordMetadata recordMetadata = future.get();

                        final String partition = String.valueOf(Thread.currentThread().getName() + "->" + recordMetadata.partition());
                        tracker.increment(partition, key);

                        Thread.sleep(time);
                        if (numElementsToPublish < 0) {
                            continue;
                        }
                        if (counter < numElementsToPublish) {
                            counter++;
                        } else {
                            break;
                        }
                    }
                } catch (InterruptedException | ExecutionException e) {
                    e.printStackTrace();
                } finally {
                    System.out.println("Closing process: " + Thread.currentThread().getName());
                }
            });
        }
    }

    private static Producer<String, String> createProducer(String bootstrap) {
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrap);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);

        return new KafkaProducer<>(props);
    }
}
