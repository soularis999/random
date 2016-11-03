package com.codejam;

import java.io.*;
import java.net.URL;
import java.util.Queue;

public class Reader implements Runnable {
    private final String file;
    private final Queue<String> buy;
    private final Queue<String> sell;

    public Reader(String file, Queue<String> buy, Queue<String> sell)
    {
        this.file = file;
        this.buy = buy;
        this.sell = sell;
    }


    public void run()
    {
        //To change body of implemented methods use File | Settings | File Templates.
        BufferedReader bufRead = null;
        try {
            bufRead = new BufferedReader(new InputStreamReader(new FileInputStream(this.file)));
            String line = null;
            long time = 0;
            long tmp = System.nanoTime();
            long num = 0;
            while((line = bufRead.readLine()) != null)
            {
                char bs = line.charAt(7);
                if("b".equalsIgnoreCase(String.valueOf(bs))) {
                    this.buy.add(line);
                }
                else if("s".equalsIgnoreCase(String.valueOf(bs)))
                {
                    this.sell.add(line);
                }
                else {
                    System.out.println("string not parsed" + line);
                }

                time += System.nanoTime() - tmp;
                tmp = System.nanoTime();
                num++;
            }

            // 1.3-1.4 microsec
            System.out.println("Avg read in nanosec: " + (time / num));

            this.buy.add("END");
            this.sell.add("END");
        }
        catch (IOException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            return;
        }
        finally
        {
            if(null != bufRead)
            {
                try
                {
                    bufRead.close();
                }
                catch (IOException e)
                {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }
        }
    }
}
