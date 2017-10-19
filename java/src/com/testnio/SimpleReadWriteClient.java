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

        outer: for (int i = 0; i < 5; i++) {
            System.out.println("writing");
            write();
            System.out.println("reading");

            int total = 0;
            while (true) {
                int read = read();
                if (-1 == read) {
                    break outer;
                }
                total += read;
                if (total >= 512 * 1024) {
                    break;
                }
            }

            Thread.sleep(200);
            System.out.println("writing");
            write();
            System.out.println("reading");

            total = 0;
            while (true) {
                int read = read();
                if (-1 == read) {
                    break outer;
                }
                if (total + read >= 512 * 1024) {
                    break;
                }
            }
        }

        channel.close();
    }

    private static int read() throws IOException {
        byteBuffer.clear();
        int total = 0;
        while (byteBuffer.remaining() > 0) {
            int read = channel.read(byteBuffer);
            if (-1 == read) {
                return -1;
            }
            System.out.println("read: " + read);
            total += read;
        }
        return total;
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
