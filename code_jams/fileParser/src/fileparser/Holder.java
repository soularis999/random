package fileparser;

import java.util.*;
import java.util.regex.Pattern;

public final class Holder
{
    private final Map<String, HolderAttr> letter =  new HashMap<String, HolderAttr>();
    private final Map<String, HolderAttr> chars =   new HashMap<String, HolderAttr>();
    private final Map<String, HolderAttr> numbers = new HashMap<String, HolderAttr>();
    private final Map<String, HolderAttr> words =   new HashMap<String, HolderAttr>();

    Pattern numberPattern = Pattern.compile("^\\d+$");
    Pattern letterPattern = Pattern.compile("^[a-zA-Z]$");

    public Holder() {}

    public enum RESULT_TYPE {
        LETTER,
        CHARACTER,
        NUMBER,
        WORD
    }

    public void parseLine(String str)
    {
        if(null == str || str.length() < 1)
        {
            return;
        }

        StringTokenizer st = new StringTokenizer(str);
        while(st.hasMoreTokens())
        {
            String token = st.nextToken();

            if(null == token || token.length() < 1)
            {
                continue;
            }

            // add word to map
            addToMap(words, token, 1);
            // check number
            if(numberPattern.matcher(token).matches())
            {
                addToMap(numbers,  token, 1);
            }

            // process chars
            for(Character ch : token.toCharArray())
            {
                if(null == ch)
                {
                    continue;
                }

                // add char
                addToMap(chars, ch.toString(), 1);
                // add letter
                if(letterPattern.matcher(ch.toString()).matches())
                {
                    addToMap(letter, ch.toString(), 1);
                }
            }
        }
    }

    public void merge(Holder holder)
    {
        merge(this.chars, holder.chars);
        merge(this.letter, holder.letter);
        merge(this.numbers, holder.numbers);
        merge(this.words, holder.words);
    }

    private void merge(Map<String, HolderAttr> toMap, Map<String,HolderAttr> fromMap)
    {
        synchronized (fromMap)
        {
            for(HolderAttr attr: fromMap.values())
            {
                addToMap(toMap, attr.getKey(), attr.getNum());
            }
        }
    }

    /**
     * Given the type of the aggregation to calculate and the number of items to add
     * the method returns a list of the items sorted in ascending order (from lowest to highest)
     * @param type
     * @param numItems
     * @return
     */
    public List<HolderAttr> getBest(RESULT_TYPE type, long numItems)
    {
        if(numItems < 1)
        {
            return new LinkedList<HolderAttr>();
        }

        Collection<HolderAttr> col;
        switch(type)
        {
            case LETTER:
                col = getBest(letter, numItems);
                break;
            case CHARACTER:
                col = getBest(chars, numItems);
                break;
            case NUMBER:
                col = getBest(numbers, numItems);
                break;
            case WORD:
                col = getBest(words, numItems);
                break;
            default:
                col = new LinkedList<HolderAttr>();
        }

        List<HolderAttr> list= new LinkedList<HolderAttr>(col);
        Collections.sort(list);
        return list;
    }

    private void addToMap(Map<String, HolderAttr> map, String key, long value)
    {
        synchronized (map)
        {
            if(!map.containsKey(key))
            {
                map.put(key, new HolderAttr(key));
            }
            map.get(key).add(value);
        }
    }

    private Collection<HolderAttr> getBest(Map<String, HolderAttr> map, long num)
    {
        PriorityQueue<HolderAttr> queue = new PriorityQueue<HolderAttr>();
        synchronized (map)
        {
            for(HolderAttr attr : map.values())
            {
                queue.add(attr);
                if(queue.size() > num) {
                    queue.poll();
                }
            }
        }
        return queue;
    }
}
