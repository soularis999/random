package com.codejam;

import javax.jnlp.FileSaveService;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.util.List;
import java.util.Queue;

public class NIOReader implements Runnable {

    private final String file;
    private final FileChannel fobuy;
    private final FileChannel fosell;

    private static final int NUM_BYTES_READ = 1024;
    private static final int NUM_BYTES_TRNSF = 50;

    private static final int CR = 13;
    private static final int LF = 10;

    private static final int BUY = 66;
    private static final int SELL = 83;

    public NIOReader(String file, FileChannel buy, FileChannel sell)
    {
        this.file = file;
        this.fobuy = buy;
        this.fosell = sell;
    }

    public void run()
    {
        FileChannel fic = null;
        ByteWriter bw = new ByteWriter();

        try
        {
            fic = new FileInputStream(this.file).getChannel();
            bw.init();

            byte [] readBuffer = new byte[NUM_BYTES_READ];
            ByteBuffer read = ByteBuffer.wrap(readBuffer);
            int numBytes = 0;

            byte[] trnsfBuffer = new byte[NUM_BYTES_TRNSF];
            int trnsfNumBytes = 0;
            boolean prepWrite = false;

            while((numBytes = fic.read(read)) > -1)
            {
                for(int i = 0; i < numBytes; i++)
                {
                    trnsfBuffer[trnsfNumBytes] = readBuffer[i];
                    trnsfNumBytes++;

                    if(LF == readBuffer[i])
                    {
                        bw.process(trnsfNumBytes, trnsfBuffer);
                        trnsfBuffer = new byte[NUM_BYTES_TRNSF];
                        trnsfNumBytes = 0;
                        prepWrite = false;
                    }
                }
                read.clear();
            }
        }
        catch (IOException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        finally
        {
            if(null != fic) {
                try {
                    fic.close();
                } catch (IOException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }

            try {
                bw.close();
            } catch (IOException e) {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        }
    }

    private class ByteWriter
    {
        private ByteBuffer buy;
        private ByteBuffer sell;

        private static final int NUM_BYTES_FOR_WRITE = 1024;

        public ByteWriter() {}

        public void init() throws IOException
        {
            buy = ByteBuffer.allocate(NUM_BYTES_FOR_WRITE);
            sell = ByteBuffer.allocate(NUM_BYTES_FOR_WRITE);
        }

        public void process(int numBytes, byte[] buffer) throws IOException
        {
            ByteBuffer buf = null;
            FileChannel ch = null;

            if(BUY == buffer[7])
            {
                buf = buy;
                ch = fobuy;
            }
            else if(SELL == buffer[7])
            {
                buf = sell;
                ch = fosell;
            }
            else
            {
                System.out.println("none");
            }

            if(null == buf || null == ch) {
                return;
            }

            if(buf.remaining() < (numBytes))
            {
                writeBuffer(buf, ch);
                buf.clear();
            }

            for(int i = 0; i < numBytes; i++)
            {
                buf.put(buffer[i]);
            }
        }


        private void writeBuffer(ByteBuffer buf, FileChannel fl) throws IOException
        {
            buf.flip();
            fl.write(buf);
        }

        public void close() throws IOException
        {
            writeBuffer(buy, fobuy);
            writeBuffer(sell, fosell);

            buy.clear();
            sell.clear();
        }
    }
}
