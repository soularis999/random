package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class SimpleReadClient {

    public static void main(String[] str) throws IOException, InterruptedException {
        SocketChannel channel = SocketChannel.open(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));
        ByteBuffer byteBuffer = ByteBuffer.allocate(512 * 1024);
        while(channel.read(byteBuffer) > 0) {
            System.out.println(byteBuffer.position());
        }

        Thread.sleep(200);
        channel.close();
    }
}
