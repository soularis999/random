package com.testnio;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class SimpleWriteClient {

    public static void main(String[] str) throws IOException {
        SocketChannel channel = SocketChannel.open(new InetSocketAddress(InetAddress.getLoopbackAddress(), 9999));
        ByteBuffer byteBuffer = ByteBuffer.allocate(512 * 1024);
        for (int i = 0; i < 512 * 1024 / 4; i++) {
            byteBuffer.putInt(i);
        }
        byteBuffer.flip();

        while (0 != byteBuffer.remaining()) {
            channel.write(byteBuffer);
        }
        channel.close();
    }
}