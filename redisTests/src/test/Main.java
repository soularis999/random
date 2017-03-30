package test;

import com.sun.xml.internal.messaging.saaj.util.ByteOutputStream;
import redis.clients.jedis.Jedis;

import java.io.*;
import java.nio.ByteBuffer;
import java.util.*;

public class Main {

    public static class Contract implements Serializable {
        int contractId;
        String symbol, exchange;

        public Contract() {
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            Contract contract = (Contract) o;

            if (contractId != contract.contractId) return false;
            if (symbol != null ? !symbol.equals(contract.symbol) : contract.symbol != null) return false;
            return exchange != null ? exchange.equals(contract.exchange) : contract.exchange == null;
        }

        @Override
        public int hashCode() {
            int result = contractId;
            result = 31 * result + (symbol != null ? symbol.hashCode() : 0);
            result = 31 * result + (exchange != null ? exchange.hashCode() : 0);
            return result;
        }
    }

    /*
    start with -ea
     */
    public static void main(String[] str) throws IOException, ClassNotFoundException {
        Contract contract = new Contract();
        contract.contractId = 1;
        contract.symbol = "SPY";
        contract.exchange = "XNYS";

        Jedis jedis = new Jedis("localhost");


        // **************** STRINGS
        jedis.del(intToByteArray(contract.contractId));

        // set “testKey” “test data”
        jedis.set(intToByteArray(contract.contractId), contractToByteArray(contract));
        // get "testKey"
        byte[] result = jedis.get(intToByteArray(contract.contractId));
        assert contract.equals(byteArrayToContract(result)): "Getting contract by id returns different contract";






        // **************** HASHES

        // hset contractid "symbol" "SPY"
        jedis.del(intToByteArray(contract.contractId));

        jedis.hset(intToByteArray(contract.contractId), "description".getBytes(), "contract description".getBytes());
        // hget contractid "symbol" "SPY"
        assert Arrays.equals("contract description".getBytes(),
                jedis.hget(intToByteArray(contract.contractId), "description".getBytes())) : "Descriptions are not equal";
        jedis.del(intToByteArray(contract.contractId));


        Map<byte[], byte[]> map = new HashMap<>();
        map.put("contract".getBytes(), contractToByteArray(contract));
        map.put("description".getBytes(), "the contract description".getBytes());
        jedis.hmset(intToByteArray(contract.contractId), map);

        // hmget contractid "symbol" "exchange"
        List<byte[]> values = jedis.hmget(intToByteArray(contract.contractId), "contract".getBytes(), "description".getBytes());
        assert Arrays.equals(contractToByteArray(contract),         values.get(0)) : "Contract in map is not same as contract in redis";
        assert Arrays.equals("the contract description".getBytes(), values.get(1)) : "Description in map is not same as contract in redis";

        map = jedis.hgetAll(intToByteArray(contract.contractId));
        assert Arrays.equals(contractToByteArray(contract),         map.get("contract".getBytes()))    : "Contract in map is not same as contract in redis";
        assert Arrays.equals("the contract description".getBytes(), map.get("description".getBytes())) : "Description in map is not same as contract in redis";



        // **************** LISTS
        jedis.del("XNYS");

        // lpush XNYS SPY - LIFO
        jedis.lpush("XNYS", "SPY");
        jedis.lpush("XNYS", "QQQ");
        jedis.lpush("XNYS", "T");

        assert 3 == jedis.llen("XNYS") : "Length of list is " + jedis.llen("XNYS");

        assert "QQQ".equals(jedis.lrange("XNYS", 1,1).get(0)) : jedis.lrange("XNYS", 1,1);

        List<String> list = jedis.lrange("XNYS",0,1);
        assert "T".equals(list.get(0));
        assert "QQQ".equals(list.get(1));

        // **************** SETS
        jedis.sadd("SPY", "XNYS","BATS");
        jedis.sadd("QQQ", "XNYS");

        assert jedis.sismember("SPY", "BATS") : "BATS is a member of Spy exchanges";

        // inter - checks the intersect
        Set<String> set = jedis.sinter("SPY", "QQQ");
        assert 1 == set.size() : "XNYS is a member of both exchanges";
        assert set.contains("XNYS") : "XNYS is a member of both exchanges";

        // **************** SORTED SETS
        jedis.zadd("hit counters", 45.0,"service 1");
        jedis.zadd("hit counters", 30.0,"service 2");
        jedis.zadd("hit counters", 10.0,"service 3");

        assert 0 == jedis.zcount("hit counters", 50.0, 100.0) : "No service is above 50";

        // increment
        jedis.zincrby("hit counters", 10, "service 1");

        assert 1 == jedis.zcount("hit counters", 50.0, 100.0) : "Only service 1 is above 50";
        assert 1 == jedis.zrevrank("hit counters", "service 2") : "service 2 is ranked 2nd";
    }

    private static Contract byteArrayToContract(byte[] result) throws IOException, ClassNotFoundException {
        ByteArrayInputStream bs = new ByteArrayInputStream(result);
        ObjectInputStream o = new ObjectInputStream(bs);
        return (Contract) o.readObject();
    }

    private static byte[] contractToByteArray(Contract contract) throws IOException {
        ByteOutputStream bs = new ByteOutputStream();
        ObjectOutputStream o = new ObjectOutputStream(bs);
        o.writeObject(contract);
        return bs.getBytes();
    }

    private static byte[] intToByteArray(int value) {
        return ByteBuffer.allocate(4).putInt(value).array();
    }
}
