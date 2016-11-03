package fileparser;

import java.io.*;
import java.net.URL;
import java.util.concurrent.Callable;

public class Parser implements Callable<Holder>{

    private final URL url;

    public Parser(URL url)
    {
        this.url = url;
    }

    public Holder call() throws Exception
    {
        Holder hold = new Holder();
        BufferedReader bufRead = null;
        try
        {
            bufRead = new BufferedReader(getReader());
            String line = null;
            while ((line = bufRead.readLine()) != null)
            {
                hold.parseLine(line);
            }
        }
        finally
        {
            if(null != bufRead)
            {
                bufRead.close();
            }
        }

        return hold;
    }

    private Reader getReader() throws IOException
    {
        return new InputStreamReader(this.url.openStream());
    }
}
