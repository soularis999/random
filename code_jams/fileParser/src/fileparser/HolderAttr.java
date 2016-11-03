package fileparser;

import java.util.concurrent.atomic.AtomicLong;

public class HolderAttr implements Comparable<HolderAttr>
{
    private final String key;
    private final AtomicLong num;

    public HolderAttr(String key)
    {
        this(key, 0);
    }

    public HolderAttr(HolderAttr attr)
    {
        this(attr.getKey(), attr.getNum());
    }

    public HolderAttr(String key, long startItem) {
        this.key = key;
        this.num = new AtomicLong(startItem);
    }

    public String getKey()
    {
        return key;
    }

    public long add(long value)
    {
        return this.num.addAndGet(value);
    }

    public long getNum()
    {
        return this.num.get();
    }

    @Override
    public boolean equals(Object o)
    {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        HolderAttr that = (HolderAttr) o;

        if (num != null ? !num.equals(that.num) : that.num != null) return false;
        if (key != null ? !key.equals(that.key) : that.key != null) return false;

        return true;
    }

    @Override
    public int hashCode()
    {
        int result = key != null ? key.hashCode() : 0;
        result = 31 * result + (num != null ? num.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "HolderAttr{" +
                "key='" + key + '\'' +
                ", num=" + num +
                '}';
    }

    public int compareTo(HolderAttr holderAttr)
    {
        if(null == holderAttr) { return 1; }

        long number = holderAttr.getNum();
        long thisNumber = this.getNum();

        if(number < thisNumber)
        {
            return 1;
        }
        else if(number > thisNumber)
        {
            return -1;
        }

        return 0;
    }
}