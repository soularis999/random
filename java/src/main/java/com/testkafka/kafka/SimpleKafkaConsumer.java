package com.testkafka.kafka;


import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Collection;
import java.util.Collections;
import java.util.Properties;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class SimpleKafkaConsumer {

    private final static String TOPIC = "test.topic";
    private final static String GROUP = "test.group";

    private static int numThreads = 0;

    public SimpleKafkaConsumer() {
    }


    private static Consumer<String, String> createConsumerConfig(String bootstrap, String groupId) {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrap);
        props.put("group.id", groupId);
        props.put("zookeeper.session.timeout.ms", "400");
        props.put("zookeeper.sync.time.ms", "200");
        props.put("auto.commit.interval.ms", "1000");
        props.put("enable.auto.commit", "false");
        props.put("key.serializer", StringSerializer.class);
        props.put("value.serializer", StringSerializer.class);
        props.put("key.deserializer", StringDeserializer.class);
        props.put("value.deserializer", StringDeserializer.class);

        return new KafkaConsumer<>(props);
    }

    private void run(final String bootstrap, final Executor executor, int threadCount) {
        for (int i = 0; i < threadCount; i++) {
            executor.execute(() -> {
                System.out.println("Starting process: " + Thread.currentThread().getName());

                try (Consumer<String, String> consumer = createConsumerConfig(bootstrap, GROUP)) {
                    consumer.subscribe(Collections.singletonList(TOPIC), new ConsumerRebalanceListener() {
                        @Override
                        public void onPartitionsRevoked(Collection<TopicPartition> partitions) {
                            for (TopicPartition partition : consumer.assignment()) {
                                System.out.println(String.format("revoking: %s, %s->%s",
                                        Thread.currentThread().getName(), partition.topic(), partition.partition()));
                            }
                        }

                        @Override
                        public void onPartitionsAssigned(Collection<TopicPartition> partitions) {
                            for (TopicPartition partition : consumer.assignment()) {
                                System.out.println(String.format("assign: %s, %s->%s",
                                        Thread.currentThread().getName(), partition.topic(), partition.partition()));
                            }
                        }
                    });
                    consumer.poll(0);

                    for (TopicPartition partition : consumer.assignment()) {
                        System.out.println(String.format("Partition assigned: %s, %s->%s",
                                Thread.currentThread().getName(), partition.topic(), partition.partition()));
                        consumer.seek(partition, 130);
                    }

                    while (true) {
                        ConsumerRecords<String, String> records = consumer.poll(100);
                        for (ConsumerRecord<String, String> record : records) {
                            System.out.println(
                                    String.format(
                                            "Thread -> %s, Topic -> %s, Offset -> %s, Partition -> %s, Key -> %s, Message -> %s",
                                            Thread.currentThread().getName(),
                                            record.topic(),
                                            record.offset(),
                                            record.partition(),
                                            record.key(),
                                            record.value()
                                    )
                            );
                        }
                    }
                } finally {
                    System.out.println("Shutting down Thread: " + Thread.currentThread().getName());
                }
            });
        }
    }


    public static void main(String[] args) {
        String bootstrap = args[0];
        int threadCount = Integer.parseInt(args[1]);

        SimpleKafkaConsumer example = new SimpleKafkaConsumer();
        Executor executor = Executors.newFixedThreadPool(threadCount, r -> {
            numThreads++;
            return new Thread(r, "Thread" + numThreads);
        });

        example.run(bootstrap, executor, threadCount);

        while (true) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException ie) {
                ie.printStackTrace();
            }
        }
    }
}
