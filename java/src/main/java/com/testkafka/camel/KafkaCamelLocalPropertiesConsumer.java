package com.testkafka.camel;

import com.testkafka.trackers.PartitionToKeyToCountTracker;
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.properties.PropertiesComponent;
import org.apache.camel.impl.DefaultCamelContext;

import java.util.Properties;

public class KafkaCamelLocalPropertiesConsumer {

    // http://kafka.apache.org/documentation.html#newconsumerconfigs
    final static String fromKafka = "kafka:{{kafka.processing.topic}}?" +
            "brokers={{kafka.host}}:{{kafka.port}}" +
            "&clientId=test.client" +
            "&groupId={{kafka.processing.group}}" +
            // If offset does not exist - where to start - earliest, latest
            "&autoOffsetReset={{kafka.processing.seekTo}}" +
            "&consumersCount={{kafka.processing.num.consumer}}";

    private static final PartitionToKeyToCountTracker tracker = new PartitionToKeyToCountTracker(true);

    public static void main(String[] str) throws Exception {
        final CamelContext camelContext = new DefaultCamelContext();

        camelContext.addRoutes(new RouteBuilder() {
            @Override
            public void configure() throws Exception {
                PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
                component.setOverrideProperties(addProperties());

                from(fromKafka).routeId("process.route").process(exchange -> {
                    exchange.getIn().getHeaders();
                    exchange.getIn().getBody(String.class);

                    final String partition = exchange.getIn().getHeader("kafka.PARTITION", String.class);
                    final String key = exchange.getIn().getHeader("kafka.KEY", String.class);
                    tracker.increment(partition, key);
                });
            }
        });

        camelContext.start();

        // blocking
        PartitionToKeyToCountTracker.print(tracker);
    }

    private static Properties addProperties() {
        Properties properties = new Properties();
        properties.put("kafka.host", "localhost");
        properties.put("kafka.port", "9092");

        properties.put("kafka.processing.topic","process.topic");
        properties.put("kafka.processing.group","test.group");
        properties.put("kafka.processing.num.consumer","3");
        properties.put("kafka.processing.seekTo","beginning");

        return properties;
    }
}
