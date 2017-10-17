package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class SimpleReadWriteClient {

    private static SocketChannel channel;
    private static ByteBuffer byteBuffer = ByteBuffer.allocate(512 * 1024);

    public static void main(String[] str) throws IOException, InterruptedException {
        channel = SocketChannel.open(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));
        channel.configureBlocking(true);

        System.out.println("writing");
        write();
        System.out.println("reading");
        read();
        Thread.sleep(200);
        System.out.println("writing");
        write();
        System.out.println("reading");
        read();

        channel.close();
    }

    private static void read() throws IOException {
        byteBuffer.clear();
        int count = 0;
        while (byteBuffer.remaining() > 0) {
            count += channel.read(byteBuffer);
            System.out.println("read: " + count);
        }
    }

    private static void write() throws IOException {
        byteBuffer.clear();
        for (int i = 0; i < 512 * 1024 / 4; i++) {
            byteBuffer.putInt(i);
        }
        byteBuffer.flip();

        int count = 0;
        while (0 != byteBuffer.remaining()) {
            count += channel.write(byteBuffer);
            System.out.println("write: " + count);
        }
    }
}
