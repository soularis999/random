package com.testnio;

import java.io.IOException;
import java.net.*;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.Iterator;

public class SimpleUdpReadServer {

    private Selector selector;
    private DatagramChannel channel;
    private ByteBuffer buffer = ByteBuffer.allocateDirect(512 * 1024);

    int readkey = 0;
    int acceptkey = 0;
    int numKeys = 0;

    int count = 0;

    public static void main(String[] str) throws IOException {
        new SimpleUdpReadServer().start();
    }

    private void start() throws IOException {
        selector = Selector.open();
        channel = selector.provider().openDatagramChannel(StandardProtocolFamily.INET);

        channel
                .setOption(StandardSocketOptions.SO_REUSEADDR, true)
                .bind(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999))
                .setOption(StandardSocketOptions.IP_MULTICAST_IF, NetworkInterface.getByName("lo0"))
                .setOption(StandardSocketOptions.IP_MULTICAST_TTL, 16)
                .setOption(StandardSocketOptions.IP_MULTICAST_LOOP, false);

        channel.configureBlocking(false);
        channel.register(selector, SelectionKey.OP_READ);

        for (; ; ) {
            try {
                if (numKeys != selector.keys().size()) {
                    numKeys = selector.keys().size();
                    System.out.println("Num of keys:" + numKeys);
                }

                int count = selector.select(100);
                if (0 == count) {
                    continue;
                }

                Iterator<SelectionKey> iter = selector.selectedKeys().iterator();
                while (iter.hasNext()) {
                    SelectionKey key = iter.next();
                    System.out.println(key.isValid());
                    iter.remove();
                    if (key.isReadable()) {
                        readKey(key);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        }
    }

    private void readKey(SelectionKey key) throws IOException {
        DatagramChannel channel = (DatagramChannel) key.channel();
        channel.receive(buffer);
        System.out.println((count++) + " Num bytes " + buffer.position());
        buffer.clear();
    }
}
