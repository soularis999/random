import com.sun.org.apache.bcel.internal.generic.NEW;
import fileparser.Holder;
import fileparser.Parser;
import org.junit.Test;

import java.io.*;
import java.net.URL;

import static org.junit.Assert.assertEquals;

public class ParserTest {

    @Test(expected = IllegalArgumentException.class)
    public void testParserThrowIllegalArgument() throws Exception {
        Parser p = new Parser(null);
        p.call();
    }

    @Test(expected = IOException.class)
    public void testParserThrowIOException() throws Exception
    {
        Parser p = new Parser(new URL("bla2.txt"));
        // file does not exist
        p.call();
    }

    @Test
    public void testEmptyParser() throws Exception
    {
        File f = new File("bla.txt");
        if(f.exists())
        {
            f.delete();
        }
        f.createNewFile();

        Parser p = new Parser(new URL("bla.txt"));
        // file does not exist
        Holder h = p.call();

        test(h, 100, 0, 0, 0, 0);
    }

    @Test
    public void testParser() throws Exception
    {
        File f = new File("bla.txt");
        PrintWriter pwr = null;
        try
        {
            if(f.exists())
            {
                f.delete();
            }
            f.createNewFile();

            pwr = new PrintWriter(new BufferedWriter(new FileWriter(f)));
            pwr.println("this is just a test");
            pwr.println("testing this r2d2 words: 2700001 times");
        }
        finally
        {
            if(null != pwr) {
                pwr.close();
            }
        }

        Parser p = new Parser(new URL("bla.txt"));
        // file does not exist
        Holder h = p.call();

        test(h, 100, 20, 15, 1, 10);
    }

    private void test(Holder h, long max, long chars, long letters, long numbers, long words) {
        assertEquals("num chars", chars, h.getBest(Holder.RESULT_TYPE.CHARACTER, max).size());
        assertEquals("num chars", letters, h.getBest(Holder.RESULT_TYPE.LETTER, max).size());
        assertEquals("num chars", numbers, h.getBest(Holder.RESULT_TYPE.NUMBER, max).size());
        assertEquals("num chars", words, h.getBest(Holder.RESULT_TYPE.WORD, max).size());
    }
}
