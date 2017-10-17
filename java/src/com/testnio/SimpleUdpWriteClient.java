package com.testnio;

import java.io.IOException;
import java.net.*;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;

public class SimpleUdpWriteClient {

    volatile static boolean flag = false;

    public static void main(String[] str) throws IOException, InterruptedException {
        final DatagramChannel channel = DatagramChannel.open(StandardProtocolFamily.INET);

        channel
                .setOption(StandardSocketOptions.SO_REUSEADDR, true)
                .setOption(StandardSocketOptions.IP_MULTICAST_IF, NetworkInterface.getByName("lo0"))
                .setOption(StandardSocketOptions.IP_MULTICAST_TTL, 16)
                .setOption(StandardSocketOptions.IP_MULTICAST_LOOP, false);

        channel.configureBlocking(false);
        channel.connect(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));

        for (int i = 0; i < 3; i++) {
            new Thread(() -> {
                ByteBuffer byteBuffer = ByteBuffer.allocate(512);
                for (int j = 0; j < 512 / 4; j++) {
                    byteBuffer.putInt(j);
                }
                byteBuffer.flip();

                while (!flag) {
                }
                run(byteBuffer, channel);
            }).start();
        }
        Thread.sleep(100);
        flag = true;
        Thread.sleep(500);

        channel.close();
    }

    private static void run(ByteBuffer byteBuffer, DatagramChannel channel) {
        for (int j = 0; j < 100; j++) {
            int length = 0;
            try {
                length = channel.write(byteBuffer);
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (0 == byteBuffer.remaining()) {
                byteBuffer.flip();
            } else {
                System.out.println("Could not send everything. Only sent " + length);
            }
        }
    }
}
