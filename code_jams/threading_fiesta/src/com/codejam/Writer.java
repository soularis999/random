package com.codejam;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.NonWritableChannelException;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;

public class Writer implements Runnable
{
    private final Queue<String> queue;
    private final String fileToWrite;
    private final int numFiles;

    public Writer(Queue<String> queue, String fileToWrite, int numFiles)
    {
        this.queue = queue;
        this.fileToWrite = fileToWrite;
        this.numFiles = numFiles;
    }

    public void run()
    {
        BufferedWriter bf = null;
        try
        {
            List<String> end = new ArrayList<String>();
            bf = new BufferedWriter(new FileWriter(this.fileToWrite));
            String str;

            long time = 0;
            long tmp = System.nanoTime();
            long num = 0;

            while(true)
            {
                str = queue.poll();
                if(null == str) { continue; }

                if(str.startsWith("END"))
                {
                    end.add(str);
                    if(this.numFiles == end.size())
                    {
                        break;
                    }
                    else
                    {
                        continue;
                    }
                }
                bf.write(str + "\n");

                time += System.nanoTime() - tmp;
                tmp = System.nanoTime();
                num ++;
            }

            // Write time - 0.6 - 1.2 microsec
            System.out.println("avg write in nanosec: " + time / num);
        }
        catch (IOException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        finally
        {
            if(null != bf) {
                try {
                    bf.close();
                } catch (IOException e) {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }
        }
    }
}
