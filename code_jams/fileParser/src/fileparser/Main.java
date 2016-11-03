package fileparser;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

public final class Main
{
    private static final int BEST_WORD_NUM = 10;
    private static final int BEST_CHAR_NUM = 3;
    private static final int BEST_LETTER_NUM = 5;
    private static final int BEST_NUMBER_NUM = 3;


    public static void main(String[] str) throws ExecutionException, InterruptedException, MalformedURLException
    {
        if(null == str || str.length < 1)
        {
            printUsage();
            return;
        }

        Runner run = null;
        try
        {
            run = new Runner();
            Holder holder = run.start(getUrls(str));
            printStats(holder);
        }
        finally
        {
            if(null != run)
            {
                run.close();
            }
        }
    }

    private static void printUsage()
    {
        System.out.println("Usage: java fileparser.Main [file1|url1] [file2|url2] ... [fileN|urlN] where file is file:///path to file");
    }

    private static List<String> getUrls(String[] str)
    {
        List<String> urls = new ArrayList<String>();
        for(int i = 0; i < str.length; i++)
        {
            if(null != str[i] && str[i].trim().length() > 0)
            {
                urls.add(str[i].trim());
            }
        }
        return urls;
    }

    private static void printStats(Holder holder)
    {
        System.out.println("Best words are: " + holder.getBest(Holder.RESULT_TYPE.WORD, BEST_WORD_NUM));
        System.out.println("Best characters are: " + holder.getBest(Holder.RESULT_TYPE.CHARACTER, BEST_CHAR_NUM));
        System.out.println("Best letters are: " + holder.getBest(Holder.RESULT_TYPE.LETTER, BEST_LETTER_NUM));
        System.out.println("Best numbers are: " + holder.getBest(Holder.RESULT_TYPE.NUMBER, BEST_NUMBER_NUM));
    }
}
