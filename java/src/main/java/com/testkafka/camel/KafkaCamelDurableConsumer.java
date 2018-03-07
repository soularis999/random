package com.testkafka.camel;

import com.testkafka.offload.OffloadProcessingManager;
import com.testkafka.offload.ScheduledOffloadProcessingManager;
import com.testkafka.trackers.PartitionToKeyToCountTracker;
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.kafka.KafkaConstants;
import org.apache.camel.component.kafka.KafkaEndpoint;
import org.apache.camel.component.properties.PropertiesComponent;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.impl.MemoryStateRepository;
import org.apache.camel.spi.StateRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class KafkaCamelDurableConsumer {

    private static final Logger logger = LoggerFactory.getLogger(KafkaCamelDurableConsumer.class);

    final static String PROCESS_TO_DIRECT_ROUTE = "from kafka process";

    // http://kafka.apache.org/documentation.html#newconsumerconfigs
    final static String processKafkaChannel = "kafka:{{kafka.processing.topic}}?" +
            "brokers={{kafka.host}}:{{kafka.port}}" +
            "&groupId={{kafka.processing.group}}" +
            "&consumersCount={{kafka.processing.num.consumer}}" +
            // If offset does not exist - where to start - earliest, latest
            "&keySerializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&serializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&keyDeserializer=org.apache.kafka.common.serialization.StringDeserializer" +
            "&valueDeserializer=org.apache.kafka.common.serialization.StringDeserializer";


    private static final PartitionToKeyToCountTracker tracker = new PartitionToKeyToCountTracker(false);

    private final OffsetHolder offsetHolder;
    private final OffloadProcessingManager<Void> manager;
    private final CamelContext camelContext;

    public static void main(String[] str) throws Exception {
        new KafkaCamelDurableConsumer().start();
        // blocking
        PartitionToKeyToCountTracker.print(tracker);
    }

    public KafkaCamelDurableConsumer() throws Exception {
        camelContext = new DefaultCamelContext();
        manager = new ScheduledOffloadProcessingManager<>(10, TimeUnit.SECONDS);
        offsetHolder = new OffsetHolder(camelContext);
    }

    private void start() throws Exception {
        camelContext.start();

        offsetHolder.init();

        manager.addOffloader(offsetHolder);
        manager.init(null);

        camelContext.addRoutes(new ProcessingRouteBuilder());
    }

    private class ProcessingRouteBuilder extends RouteBuilder {

        private final Map<String, String> map = new ConcurrentHashMap<>();

        @Override
        public void configure() throws Exception {


            PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
            component.setLocation("classpath:application.properties");


            // get messge from processing topic
            from(processKafkaChannel).process(exchange -> {

                final String topic = exchange.getIn().getHeader(KafkaConstants.TOPIC, String.class);
                final Integer partition = exchange.getIn().getHeader(KafkaConstants.PARTITION, Integer.class);
                final Long offset = exchange.getIn().getHeader(KafkaConstants.OFFSET, Long.class);
                final String key = exchange.getIn().getHeader(KafkaConstants.KEY, String.class);

                if (!map.containsKey(topic + "/" + partition)) {
                    logger.info(String.format("Processing %s %s %s", topic, partition, offset));
                    map.put(topic + "/" + partition, topic + "/" + partition);
                }

                try {
                    manager.begin();

                    tracker.increment(Thread.currentThread().getName() + "->" + partition, key);
                    offsetHolder.update(topic, partition, offset);

                } finally {
                    manager.commit();
                }

            }).routeId(PROCESS_TO_DIRECT_ROUTE).end();

            StateRepository<String, String> repository = new MemoryStateRepository();
            long count = offsetHolder.populate(repository);

            if (count > 0) {
                KafkaEndpoint endpoint = camelContext.getEndpoint(processKafkaChannel, KafkaEndpoint.class);
                endpoint.getConfiguration().setOffsetRepository(repository);
            }
        }
    }
}
