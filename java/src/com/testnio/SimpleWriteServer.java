package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.Iterator;

public class SimpleWriteServer {

    Selector selector;
    ServerSocketChannel channel;
    int acceptkey = 0;

    int numKeys = 0;

    public static void main(String[] str) throws IOException {
        new SimpleWriteServer().start();
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

                int count = selector.selectNow();
                if (0 == count) {
                    continue;
                }

                Iterator<SelectionKey> iter = selector.selectedKeys().iterator();
                while (iter.hasNext()) {
                    SelectionKey key = iter.next();
                    System.out.println(key.isValid());
                    System.out.println(key.interestOps());
                    System.out.println(key.attachment());
                    iter.remove();

                    if (key.isAcceptable()) {
                        acceptKey(key);
                    }
                    if (key.isWritable()) {
                        onWrite(key);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        }
    }

    private void onWrite(SelectionKey key) throws IOException {
        SocketChannel client = (SocketChannel) key.channel();
        ByteBuffer byteBuffer = (ByteBuffer) key.attachment();

        client.write(byteBuffer);
        if (byteBuffer.remaining() > 0) {
            byteBuffer.compact();
        } else {
            byteBuffer.clear();
            key.cancel();
        }
    }

    private void acceptKey(SelectionKey key) throws IOException {
        SocketChannel client = channel.accept();
        client.configureBlocking(false);

        ByteBuffer byteBuffer = ByteBuffer.allocate(512 * 1024);
        for (int i = 0; i < 512 * 1024 / 4; i++) {
            byteBuffer.putInt(i);
        }
        byteBuffer.flip();

        client.write(byteBuffer);
        if (byteBuffer.remaining() > 0) {
            byteBuffer.compact();
            client.register(selector, SelectionKey.OP_WRITE, byteBuffer);
        } else {
            byteBuffer.clear();
        }
    }
}