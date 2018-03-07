package com.testkafka.kafka;

import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.LongAdder;

public class KafkaDurableConsumer {

    private final static String TOPIC = "test.topic";
    private final static String CONTROL_TOPIC = "control.topic";
    private final static String GROUP = "test.group";

    private static int numThreads = 0;

    private final Properties kafkaProperties;
    private final Sync sync;


    public static void main(String[] args) {
        /*
        Takes string of comma delimited list of kafka servers and number of threads to run consumer
         */
        String bootstrap = args[0];
        int threadCount = Integer.parseInt(args[1]);

        /*
        Code that gets initial config from topic and sends new config every n seconds
         */
        Sync sync = new Sync(createConsumerConfig(bootstrap, GROUP));
        // read config
        sync.init();

        // processor that reads the data
        KafkaDurableConsumer example = new KafkaDurableConsumer(sync, createConsumerConfig(bootstrap, GROUP));
        Executor executor = Executors.newFixedThreadPool(threadCount, r -> {
            numThreads++;
            return new Thread(r, "Thread" + numThreads);
        });

        // run consumer - in multiple threads
        example.run(executor, threadCount);
        sync.run(); // blocking
    }

    private static Properties createConsumerConfig(String bootstrap, String groupId) {
        Properties props = new Properties();
        props.put("bootstrap.servers", bootstrap);
        props.put("group.id", groupId);
        props.put("zookeeper.session.timeout.ms", "400");
        props.put("zookeeper.sync.time.ms", "200");
        props.put("auto.commit.interval.ms", "1000");
        props.put("enable.auto.commit", "false");
        props.put("key.deserializer", StringDeserializer.class);
        props.put("value.deserializer", StringDeserializer.class);
        props.put("key.serializer", StringSerializer.class);
        props.put("value.serializer", StringSerializer.class);
        return props;
    }

    public KafkaDurableConsumer(Sync sync, Properties kafkaProperties) {
        this.sync = sync;
        this.kafkaProperties = kafkaProperties;
    }

    private void run(final Executor executor, int threadCount) {
        for (int i = 0; i < threadCount; i++) {
            executor.execute(new Processor(kafkaProperties, this.sync));
        }
    }

    private static class Processor implements Runnable {
        private final Properties properties;
        private final Sync sync;

        public Processor(Properties properties, Sync sync) {
            this.properties = properties;
            this.sync = sync;
        }

        @Override
        public void run() {
            System.out.println("Starting process: " + Thread.currentThread().getName());

            try (Consumer<String, String> consumer = new KafkaConsumer<>(properties)) {
                consumer.subscribe(Collections.singletonList(TOPIC));
                consumer.poll(0);

                for (TopicPartition partition : consumer.assignment()) {
                    Long offset = sync.getSyncMap().get(partition.partition());
                    /*
                    NOTE: If no partition in set in config - leave as is
                     */
                    if (null == offset) {
                        System.out.println(String.format("Partition assigned: %s, %s->%s to %s",
                                Thread.currentThread().getName(), partition.topic(), partition.partition(), "Latest"));
                        continue;
                    }
                    System.out.println(String.format("Partition assigned: %s, %s->%s to %s",
                            Thread.currentThread().getName(), partition.topic(), partition.partition(), offset));
                    consumer.seek(partition, offset);
                }

                while (true) {
                    ConsumerRecords<String, String> records = consumer.poll(100);
                    for (ConsumerRecord<String, String> record : records) {
                        this.sync.commit(record);
//                        System.out.println(
//                                String.format(
//                                        "Thread -> %s, Topic -> %s, Offset -> %s, Partition -> %s, Key -> %s, Message -> %s",
//                                        Thread.currentThread().getName(),
//                                        record.topic(),
//                                        record.offset(),
//                                        record.partition(),
//                                        record.key(),
//                                        record.value()
//                                )
//                        );
                    }
                }
            } finally {
                System.out.println("Shutting down Thread: " + Thread.currentThread().getName());
            }
        }
    }

    private static class Sync {
        private final Properties kafkaProperties;
        private final Map<Integer, Long> syncMap = new ConcurrentHashMap<>();
        private final LongAdder adder = new LongAdder();

        private static Map<Integer, Set<Integer>> partitionToKeyAndCount = new ConcurrentHashMap<>();

        public Sync(Properties kafkaProperties) {
            this.kafkaProperties = kafkaProperties;
        }

        public void init() {
            syncMap.clear();
            try (Consumer<String, String> consumer = new KafkaConsumer<>(kafkaProperties)) {
                consumer.subscribe(Collections.singletonList(CONTROL_TOPIC));
                consumer.poll(0);
                consumer.seekToBeginning(consumer.assignment());

                int count = 0;
                do {
                    System.out.println("Count " + count);
                    ConsumerRecords<String, String> records = consumer.poll(100);
                    for (ConsumerRecord<String, String> record : records) {
                        String data = record.value();
                        System.out.println(
                                String.format(
                                        "Thread -> %s, Topic -> %s, Offset -> %s, Partition -> %s, Key -> %s, Message -> %s",
                                        Thread.currentThread().getName(),
                                        record.topic(),
                                        record.offset(),
                                        record.partition(),
                                        record.key(),
                                        data
                                )
                        );

                        for (String partitionData : data.split("\\|")) {
                            String[] tmp = partitionData.split(":");
                            if (2 != tmp.length) {
                                continue;
                            }
                            int partition = Integer.parseInt(tmp[0]);
                            long offset = Long.parseLong(tmp[1]);
                            syncMap.put(partition, offset);
                        }
                    }
                }
                while (count++ < 5);
            }
        }

        public Map<Integer, Long> getSyncMap() {
            return Collections.unmodifiableMap(syncMap);
        }

        public void commit(ConsumerRecord<String, String> record) {
            syncMap.put(record.partition(), record.offset());
            Set<Integer> keys = new HashSet<>();
            Set<Integer> temp = partitionToKeyAndCount.putIfAbsent(record.partition(), keys);
            if (null != temp) {
                keys = temp;
            }
            keys.add(Integer.parseInt(record.key()));
            adder.increment();
        }

        public void run() {
            while (true) {
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                if (0 == syncMap.size()) {
                    continue;
                }

                StringBuilder sb = new StringBuilder();
                /*
                NOTE: because this is time based queue we should still publish message even if nothing changed
                to move the expiration
                 */
                for (Map.Entry<Integer, Long> entry : syncMap.entrySet()) {
                    sb.append(entry.getKey()).append(":").append(entry.getValue()).append("|");
                }

                try (Producer<String, String> producer = new KafkaProducer<>(this.kafkaProperties)) {
                    ProducerRecord<String, String> record = new ProducerRecord<>(CONTROL_TOPIC, sb.toString());
                    producer.send(record);
                } finally {
                    System.out.println("Published: " + sb);
                }

                for (Map.Entry<Integer, Set<Integer>> itr : partitionToKeyAndCount.entrySet()) {
                    for (Integer key : itr.getValue()) {
                        System.out.println(String.format("Partition %s, key %s", itr.getKey(), key));
                    }
                }
            }
        }
    }
}
