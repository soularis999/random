package com.testkafka.camel;

import org.apache.camel.CamelContext;
import org.apache.camel.Endpoint;
import org.apache.camel.Exchange;
import org.apache.camel.Producer;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.properties.PropertiesComponent;
import org.apache.camel.impl.DefaultCamelContext;

import java.util.Properties;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class KafkaPublisher {

    final static String directChannel = "direct:start";
    final static String logChannel = "log:com.testkafka?level=INFO&showBody=true&showHeaders=true";

    final static String adminKafkaChannel = "kafka:{{kafka.topic}}?" +
            "brokers={{kafka.bootstrap}}" +
            "&groupId={{kafka.group}}" +
            // If offset does not exist - where to start - earliest, latest
            "&seekTo=beginning" +
            "&autoCommitEnable=false" +
            "&keySerializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&serializerClass=org.apache.kafka.common.serialization.StringSerializer" +
            "&keyDeserializer=org.apache.kafka.common.serialization.StringDeserializer" +
            "&valueDeserializer=org.apache.kafka.common.serialization.StringDeserializer";

    public static void main(String[] args) throws Exception {
        String bootstrap = args[0];
        int threadCount = Integer.parseInt(args[1]);
        final int time;
        if (args.length > 2) {
            time = Integer.parseInt(args[2]);
        } else {
            time = 100;
        }

        final int num;
        if (args.length > 3) {
            num = Integer.parseInt(args[3]);
        } else {
            num = -1;
        }

        CamelContext camelContext = new DefaultCamelContext();
        camelContext.addRoutes(new RouteBuilder() {

            @Override
            public void configure() throws Exception {
                Properties properties = new Properties();
                properties.put("kafka.topic", "process.topic");
                properties.put("kafka.bootstrap", bootstrap);
                properties.put("kafka.group", "admin.group");
                PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
                component.setInitialProperties(properties);

                // publish to admin topic
                from(directChannel).to(logChannel).to(adminKafkaChannel).routeId("Test");
            }
        });

        camelContext.start();

        ExecutorService service = Executors.newFixedThreadPool(threadCount);
        for (int i = 0; i < threadCount; i++) {
            service.submit(() -> {
                try {
                    Endpoint endpoint = camelContext.getEndpoint(directChannel);
//                    Producer producer = endpoint.createProducer();
                    Exchange exchange = endpoint.createExchange();
//                    producer.start();
                    ProducerTemplate producerTemplate = camelContext.createProducerTemplate();

                    int count = 0;
                    while (num == -1 || count < num) {
                        exchange.getIn().setBody("test " + System.currentTimeMillis());
                        exchange.getIn().setHeader("Test header 1", "header 1");
                        exchange.getIn().setHeader("Test header 2", System.currentTimeMillis());
                        CompletableFuture f = producerTemplate.asyncSend(endpoint, exchange);

                        f.get(1, TimeUnit.SECONDS);

                        TimeUnit.MILLISECONDS.sleep(time);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
        }
    }
}
