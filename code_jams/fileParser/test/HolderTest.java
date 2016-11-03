import com.sun.tools.corba.se.idl.IncludeGen;
import fileparser.Holder;
import fileparser.HolderAttr;
import org.junit.Test;
import sun.tools.jstat.Parser;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;

import static org.junit.Assert.*;
import static org.junit.Assert.assertEquals;


public class HolderTest {

    @Test
    public void testHolderParse() throws Exception {
        Holder h = new Holder();
        h.parseLine(null);
        test(h, 100, 0, 0, 0, 0);

        h = new Holder();
        h.parseLine("");
        test(h, 100, 0, 0, 0, 0);

        h = new Holder();
        h.parseLine("this is just a test");
        test(h, 100, 8, 8, 0, 5);

        h = new Holder();
        h.parseLine("testing the r2d2 words: 2700001 times");
        test(h, 100, 17, 12, 1, 6);

        h = new Holder();
        h.parseLine("abcdefgh abcdefg abcdef abcde abcd abc ab a");
        Collection<HolderAttr> col = h.getBest(Holder.RESULT_TYPE.CHARACTER, 3);
        Iterator<HolderAttr> iter = col.iterator();

        HolderAttr attr = iter.next();
        assertEquals("c", attr.getKey());
        assertEquals(6, attr.getNum());

        attr = iter.next();
        assertEquals("b", attr.getKey());
        assertEquals(7, attr.getNum());

        attr = iter.next();
        assertEquals("a", attr.getKey());
        assertEquals(8, attr.getNum());
    }

    private void test(Holder h, long max, long chars, long letters, long numbers, long words) {
        assertEquals("num chars", chars, h.getBest(Holder.RESULT_TYPE.CHARACTER, max).size());
        assertEquals("num chars", letters, h.getBest(Holder.RESULT_TYPE.LETTER, max).size());
        assertEquals("num chars", numbers, h.getBest(Holder.RESULT_TYPE.NUMBER, max).size());
        assertEquals("num chars", words, h.getBest(Holder.RESULT_TYPE.WORD, max).size());
    }
}
