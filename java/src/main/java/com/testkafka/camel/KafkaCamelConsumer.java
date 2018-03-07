package com.testkafka.camel;

import com.testkafka.trackers.PartitionToKeyToCountTracker;
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.kafka.KafkaConfiguration;
import org.apache.camel.component.kafka.KafkaConstants;
import org.apache.camel.component.properties.PropertiesComponent;
import org.apache.camel.impl.DefaultCamelContext;

public class KafkaCamelConsumer {

    // http://kafka.apache.org/documentation.html#newconsumerconfigs
    final static String fromKafka = "kafka:{{kafka.processing.topic}}?" +
            "brokers={{kafka.host}}:{{kafka.port}}" +
            "&groupId={{kafka.processing.group}}" +
            "&consumersCount={{kafka.processing.num.consumer}}" +
            // If offset does not exist - where to start - earliest, latest
            "&keySerializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&serializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&keyDeserializer=org.apache.kafka.common.serialization.StringDeserializer" +
            "&valueDeserializer=org.apache.kafka.common.serialization.StringDeserializer";

    private static final PartitionToKeyToCountTracker tracker = new PartitionToKeyToCountTracker(true);

    public static void main(String[] str) throws Exception {
        final CamelContext camelContext = new DefaultCamelContext();

        camelContext.addRoutes(new RouteBuilder() {
            @Override
            public void configure() throws Exception {
                PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
                component.setLocation("classpath:application.properties");

                from(fromKafka).routeId("process.route").process(exchange -> {
                    exchange.getIn().getHeaders();
                    exchange.getIn().getBody(String.class);

                    final String partition = exchange.getIn().getHeader(KafkaConstants.PARTITION, String.class);
                    final String key = exchange.getIn().getHeader(KafkaConstants.OFFSET, String.class);
                    tracker.increment(partition, key);
                });
            }
        });

        camelContext.start();

        // blocking
        PartitionToKeyToCountTracker.print(tracker);
    }
}
