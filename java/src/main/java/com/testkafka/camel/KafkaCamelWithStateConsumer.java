package com.testkafka.camel;

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
import sun.management.counter.LongCounter;

import java.util.concurrent.atomic.LongAdder;

public class KafkaCamelWithStateConsumer {

    private static final Logger logger = LoggerFactory.getLogger(KafkaCamelWithStateConsumer.class);

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

    private final CamelContext camelContext;

    public static void main(String[] str) throws Exception {
        new KafkaCamelWithStateConsumer().start();
        // blocking
        PartitionToKeyToCountTracker.print(tracker);
    }

    public KafkaCamelWithStateConsumer() throws Exception {
        camelContext = new DefaultCamelContext();
    }

    private void start() throws Exception {
        camelContext.start();

        camelContext.addRoutes(new ProcessingRouteBuilder());
    }

    private class ProcessingRouteBuilder extends RouteBuilder {

        private final StateRepository<String, String> repository = new MemoryStateRepository();
        private final LongAdder errorLongCounter = new LongAdder();
        private final LongAdder totalLongCounter = new LongAdder();
        @Override
        public void configure() throws Exception {


            PropertiesComponent component = camelContext.getComponent("properties", PropertiesComponent.class);
            component.setLocation("classpath:application.properties");


            // get messge from processing topic
            from(processKafkaChannel).process(exchange -> {

                final String topic = exchange.getIn().getHeader(KafkaConstants.TOPIC, String.class);
                final Integer partition = exchange.getIn().getHeader(KafkaConstants.PARTITION, Integer.class);
                final Integer offset = exchange.getIn().getHeader(KafkaConstants.OFFSET, Integer.class);

                String state = repository.getState(topic + '/' + partition);
                if (null != state) {
//                    System.out.println(Thread.currentThread().getName() + "->" + topic + '/' + partition + "=" + state + "/" + offset);
//
//                    assert Integer.parseInt(state) == offset - 1 : Thread.currentThread().getName() + "->" + topic + '/' + partition + "=" + state + "/" + offset;
                    totalLongCounter.increment();
                    if(Integer.parseInt(state) != offset - 1) {
                        errorLongCounter.increment();
                        System.out.println(
                                Thread.currentThread().getName() + "->" + topic + '/' + partition + "=" + state + "/" + offset + "->" + errorLongCounter.longValue() + " of " + totalLongCounter.longValue());
                    }
                    tracker.increment(Thread.currentThread().getName() + "->" + partition, state);
                }

            }).routeId(PROCESS_TO_DIRECT_ROUTE);

            KafkaEndpoint endpoint = camelContext.getEndpoint(processKafkaChannel, KafkaEndpoint.class);
            endpoint.getConfiguration().setOffsetRepository(repository);
        }
    }
}
