package com.codejam;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.*;

public class Start
{
    public static final String FILE_BUY = "output/buy.txt";
    public static final String FILE_SELL = "output/sell.txt";

    private final String[] readFiles;
    private final ExecutorService exc;

    /**
     * Your program starts here. This is how your application will be tested.
     */
    public static void main(String[] args) throws ExecutionException, InterruptedException, IOException
    {
        if (args.length < 1) {
            System.out.println("no files passes");
        }

        Start strt = new Start(args);

        long start = System.currentTimeMillis();

//        strt.doio();
        strt.donewio();

        strt.close();

        System.out.println("Time taken: " + (System.currentTimeMillis() - start) + " msec");

    }

    public Start(String [] readFiles)
    {
        this.readFiles = readFiles;
        this.exc = Executors.newFixedThreadPool(this.readFiles.length + 2);
    }

    public void doio()
    {
        Queue<String> bQueue = new LinkedBlockingQueue<String>();
        Queue<String> sQueue = new LinkedBlockingQueue<String>();

        List<Future> lst = new ArrayList<Future>();

        lst.add(exc.submit(new Writer(bQueue, FILE_BUY, this.readFiles.length)));
        lst.add(exc.submit(new Writer(sQueue, FILE_SELL, this.readFiles.length)));

        try
        {
            for(String readFile : this.readFiles)
            {
                lst.add(exc.submit(new Reader(readFile, bQueue, sQueue)));
            }

            for(Future f : lst) {
                f.get();
            }
        }
        catch (InterruptedException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        catch (ExecutionException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }

    public void donewio()
    {
        List<Future> lst = new ArrayList<Future>();

        FileChannel fobuy = null;
        FileChannel fosell = null;
        try
        {

            fobuy = new FileOutputStream(FILE_BUY, false).getChannel();
            fosell = new FileOutputStream(FILE_SELL, false).getChannel();

            for(String readFile : this.readFiles)
            {
                lst.add(exc.submit(new NIOReader(readFile, fobuy, fosell)));
            }

            for(Future f : lst) {
                f.get();
            }
        }
        catch (InterruptedException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        catch (ExecutionException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
        finally
        {
            if(null != fobuy)
            {
                try
                {
                    fobuy.close();
                }
                catch (IOException e)
                {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }

            if(null != fosell)
            {
                try
                {
                    fosell.close();
                }
                catch (IOException e)
                {
                    e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
                }
            }
        }
    }

    public void close()
    {
        this.exc.shutdown();
    }
}
