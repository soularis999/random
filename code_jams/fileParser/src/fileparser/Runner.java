package fileparser;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * Created by IntelliJ IDEA.
 * User: e11861
 * Date: 8/18/11
 * Time: 5:20 PM
 * To change this template use File | Settings | File Templates.
 */
public class Runner
{
    public static final int NUM_THREADS = 2;

    private final ExecutorService executor;

    public Runner()
    {
         executor = Executors.newFixedThreadPool(NUM_THREADS);
    }

    public Holder start(List<String> urlStrings) throws MalformedURLException {
        Holder parent = new Holder();
        if(null == urlStrings || urlStrings.size() < 1) {
            return parent;
        }

        List<URL> urls = getFiles(urlStrings);
        List<Future<Holder>> futures = new ArrayList<Future<Holder>>();
        // submit all the files to pool
        for(URL url: urls)
        {
            futures.add(executor.submit(new Parser(url)));
        }

        for(Future<Holder> future : futures)
        {
            try
            {
                Holder tmp  = future.get();
                parent.merge(tmp);
            }
            catch (Exception exc) {
                exc.printStackTrace();
            }
        }

        return parent;
    }

    public void close()
    {
        this.executor.shutdown();
    }

    private List<URL> getFiles(List<String> urltexts) throws MalformedURLException
    {
        List<URL> lst = new ArrayList<URL>();
        for(String urltext : urltexts)
        {
            URL url = new URL(urltext);
            lst.add(url);
        }
        return lst;
    }
}
