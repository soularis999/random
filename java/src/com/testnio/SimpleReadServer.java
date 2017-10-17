package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.Iterator;

public class SimpleReadServer {

    Selector selector;
    ServerSocketChannel channel;
    ByteBuffer buffer = ByteBuffer.allocateDirect(512 * 1024);

    int readkey = 0;
    int acceptkey = 0;
    int numKeys = 0;

    public static void main(String[] str) throws IOException {
        new SimpleReadServer().start();
    }

    private void start() throws IOException {
        selector = Selector.open();
        channel = selector.provider().openServerSocketChannel();

        channel.configureBlocking(false);
        channel.bind(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));
        channel.register(selector, SelectionKey.OP_ACCEPT, "accept key " + (acceptkey++));

        for (; ; ) {
            try {
                if(numKeys != selector.keys().size()) {
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

                    System.out.println(key.attachment());

                    if (key.isAcceptable()) {
                        acceptKey(key);
                    }
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
        SocketChannel channel = (SocketChannel) key.channel();
        int result = channel.read(buffer);
        if(-1 == result) {
            channel.close();
            key.cancel();
        }

        buffer.flip();
        byte[] data = new byte[buffer.remaining()];
        buffer.get(data);

        String resultData = new String(data);
        if ("\\q\r\n".equals(resultData)) {
            channel.close();
            key.cancel();
        }
        System.out.println("Num bytes " + data.length);
        System.out.println(result);
        buffer.clear();
    }

    private void acceptKey(SelectionKey key) throws IOException {
        SocketChannel client = channel.accept();
        client.configureBlocking(false);
        client.register(selector, SelectionKey.OP_READ, "read key " + (readkey++));
    }
}