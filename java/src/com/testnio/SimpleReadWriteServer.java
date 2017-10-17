package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;

public class SimpleReadWriteServer {
    Selector selector;
    ServerSocketChannel channel;

    int holderCount = 0;
    int numKeys = 0;

    public static void main(String[] str) throws IOException {
        new SimpleReadWriteServer().start();
    }

    private void start() throws IOException {
        selector = Selector.open();
        channel = selector.provider().openServerSocketChannel();

        channel.configureBlocking(false);
        channel.bind(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));
        channel.register(selector, SelectionKey.OP_ACCEPT);

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
                    try {
                        SelectionKey key = iter.next();
                        final int interestSet = key.interestOps();

                        printKey("Received key", key);

                        if ((interestSet & SelectionKey.OP_READ) != 0) {
                            readKey(key);
                        }

                        if ((interestSet & SelectionKey.OP_WRITE) != 0) {
                            onWrite(key);
                        }

                        if ((interestSet & SelectionKey.OP_ACCEPT) != 0) {
                            acceptKey(key);
                        }
                    } finally {
                        iter.remove();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
//                throw e;
            }
        }
    }

    private void onWrite(SelectionKey key) throws IOException {
        SocketChannel client = (SocketChannel) key.channel();
        Holder holder = (Holder) key.attachment();

        int result = client.write(holder.writeBuffer);
        printKey("Num bytes written:" + result, key);
        if (holder.writeBuffer.remaining() > 0) {
            holder.writeBuffer.compact();
        } else {
            holder.writeBuffer.clear();
            key.interestOps(key.interestOps() & ~SelectionKey.OP_WRITE);
        }
    }

    private void readKey(SelectionKey key) throws IOException {
        SocketChannel client = (SocketChannel) key.channel();
        Holder holder = (Holder) key.attachment();

        int result = client.read(holder.readBuffer);
        printKey("Num bytes read:" + result, key);
        if (-1 == result) {
            // Cancel if got -1 as socket is closed
            client.close();
            key.cancel();
        }

        if (0 == holder.readBuffer.remaining()) {
            holder.readBuffer.clear();
            doOnWrite(key);
        }
    }

    private void doOnWrite(SelectionKey key) throws IOException {
        SocketChannel client = (SocketChannel) key.channel();
        Holder holder = (Holder) key.attachment();

        for (int i = 0; i < 512 * 1024 / 4; i++) {
            holder.writeBuffer.putInt(i);
        }
        holder.writeBuffer.flip();

        int result = client.write(holder.writeBuffer);
        printKey("Num bytes written:" + result, key);

        if (holder.writeBuffer.position() > 0) {
            holder.writeBuffer.compact();
            key.interestOps(key.interestOps() | SelectionKey.OP_WRITE);
        } else {
            holder.writeBuffer.clear();
        }
    }

    private void acceptKey(SelectionKey key) throws IOException {
        SocketChannel client = channel.accept();
        client.configureBlocking(false);
        SelectionKey readKey = client.register(selector, SelectionKey.OP_READ);

        Holder holder = new Holder();
        holder.id = ++holderCount;
        readKey.attach(holder);
    }

    private void printKey(String action, SelectionKey key) {
        System.out.println(
                String.format("%s -> key: %s, is valid key: %s, op %s, content %s",
                        action, key, key.isValid(), key.isValid() ? key.interestOps() : "NONE", key.attachment())
        );
    }

    private class Holder {
        int id;
        ByteBuffer readBuffer = ByteBuffer.allocateDirect(512 * 1024);
        ByteBuffer writeBuffer = ByteBuffer.allocateDirect(512 * 1024);

        @Override
        public String toString() {
            return "Holder{" +
                    "id=" + id +
                    ", rpos=" + readBuffer.position() +
                    ", wpos=" + writeBuffer.position() +
                    '}';
        }
    }
}
