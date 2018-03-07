package com.testkafka.camel;

import com.testkafka.offload.OffloadProcessingManager;
import org.apache.camel.CamelContext;
import org.apache.camel.ConsumerTemplate;
import org.apache.camel.Exchange;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.properties.PropertiesComponent;
import org.apache.camel.spi.StateRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Closeable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class OffsetHolder implements OffloadProcessingManager.Offloader<Void>, Closeable {

    final static String SEPERATION_CHAR = "/";

    final static String DIRECT_TO_ADMIN_ROUTE = "to kafka admin";

    final static String directChannel = "direct:start";
    final static String logChannel = "log:com.testkafka?level=INFO";

    final static String adminKafkaChannel = "kafka:{{kafka.admin.topic}}?" +
            "brokers={{kafka.host}}:{{kafka.port}}" +
            "&groupId={{kafka.admin.group}}" +
            // If offset does not exist - where to start - earliest, latest
            "&seekTo={{kafka.admin.seekTo}}" +
            "&consumersCount={{kafka.admin.num.consumer}}" +
            "&autoCommitEnable=false" +
            "&keySerializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&serializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&keyDeserializer=org.apache.kafka.common.serialization.StringDeserializer" +
            "&valueDeserializer=org.apache.kafka.common.serialization.StringDeserializer";

    private static final Logger logger = LoggerFactory.getLogger(OffsetHolder.class);

    private final CamelContext camelContext;
    private final List<String> values = new ArrayList<>();
    private final Map<String, Long> topicAndPartitionToOffset = new ConcurrentHashMap<>();

    private ProducerTemplate producerTemplate;
    private ConsumerTemplate consumerTemplate;

    private boolean initDone = false;

    public OffsetHolder(final CamelContext camelContext) throws Exception {
        this.camelContext = camelContext;
    }

    public synchronized void init() throws Exception {
        if (initDone) {
            return;
        }

        camelContext.addRoutes(new RouteBuilder() {
            @Override
            public void configure() throws Exception {
                PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
                component.setLocation("classpath:application.properties");

                // publish to admin topic
                from(directChannel).to(logChannel).to(adminKafkaChannel).routeId(DIRECT_TO_ADMIN_ROUTE);
            }
        });

        this.producerTemplate = camelContext.createProducerTemplate();
        this.consumerTemplate = camelContext.createConsumerTemplate();

        int count = 0;
        while (true) {
            Exchange exchange = consumerTemplate.receive(adminKafkaChannel, 100);
            if (null == exchange) {
                if (10 == count) {
                    break;
                }
                count++;
                continue;
            }

            count = 0;
            String value = exchange.getIn().getBody(String.class);
            String[] data = value.split(SEPERATION_CHAR);
            if (data[1].contains("|")) {
                continue;
            }
            // TODO: add more checks
            update(data[0], Integer.parseInt(data[1]), Long.parseLong(data[2]));
        }

        System.out.println(topicAndPartitionToOffset);
        initDone = true;
    }

    /**
     * Given the repo the method populates it with data loaded from store
     */
    public long populate(StateRepository<String, String> repository) {
        return topicAndPartitionToOffset.entrySet().stream().peek(entry -> {
            repository.setState(entry.getKey(), String.valueOf(entry.getValue()));
        }).count();
    }

    @Override
    public void close() {
        try {
            this.camelContext.stop();
        } catch (Exception e) {
            // no-op
            logger.warn("Error closing offset holder. Will continue shutting down.", e);
        }
    }

    public void update(String topic, int partition, long offset) {

        String key = normalizeKey(topic, partition);

        // get old partition
        Long oldOffset = topicAndPartitionToOffset.putIfAbsent(key, offset);
        if (null == oldOffset) {
            return;
        }
        // if old offset not null - replace
        while (oldOffset < offset) {
            if (!topicAndPartitionToOffset.replace(key, oldOffset, offset)) {
                oldOffset = topicAndPartitionToOffset.get(key);
            }
        }
    }


    @Override
    public void onOffload(Void resource) throws Exception {
        values.clear();
        topicAndPartitionToOffset.entrySet().stream()
                .map((entry) -> entry.getKey() + SEPERATION_CHAR + entry.getValue())
                .collect(Collectors.toCollection(() -> values));
    }

    @Override
    public void onAfterOffload(Void resource, boolean wasExecuted, Throwable throwable) throws Exception {
        if (!wasExecuted) {
            return;
        }

        // send messages
        if (null == throwable) {
            values.forEach(value -> producerTemplate.sendBody(adminKafkaChannel, value));
        }
    }

    private static String normalizeKey(String topic, int partition) {
        return topic + SEPERATION_CHAR + partition;
    }
}
