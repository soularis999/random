package com.testavro;

import org.apache.avro.file.DataFileStream;
import org.apache.avro.file.DataFileWriter;
import org.apache.avro.io.DatumReader;
import org.apache.avro.io.DatumWriter;
import org.apache.avro.specific.SpecificDatumReader;
import org.apache.avro.specific.SpecificDatumWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.UUID;

public class AvroLoggerTest {

    private static final Logger logger = LoggerFactory.getLogger("avro_logger");

    public static void main(String[] data) throws IOException {
        ObjDto objDto = serializeAndDeserializeTweet("test", "me", 1L, "a", "bbb");
        logger.warn("Testing {}", objDto);
    }

    private static ObjDto serializeAndDeserializeTweet(String text, String author, Long timestamp, String... hashtags)
            throws IOException {

        ObjDto.Builder tweet1Builder = ObjDto.newBuilder().setId(UUID.randomUUID().toString());
        if (text != null) {
            tweet1Builder.setText(text);
        }
        if (author != null) {
            tweet1Builder.setAuthor(author);
        }

        tweet1Builder.setTimestamp(timestamp == null ? System.currentTimeMillis() : timestamp);
        if (hashtags != null) {
            tweet1Builder.setHashtags(Arrays.asList(hashtags));
        }

        ObjDto tweet1 = tweet1Builder.build();
        DatumWriter<ObjDto> tweetDatumWriter = new SpecificDatumWriter<>(ObjDto.class);
        DataFileWriter<ObjDto> dataFileWriter = new DataFileWriter<>(tweetDatumWriter);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        dataFileWriter.create(tweet1.getSchema(), outputStream);
        dataFileWriter.append(tweet1);
        dataFileWriter.close();

        ByteArrayInputStream inputStream = new ByteArrayInputStream(outputStream.toByteArray());
        DatumReader<ObjDto> tweetDatumReader = new SpecificDatumReader<>(ObjDto.class);
        DataFileStream<ObjDto> dataFileReader = new DataFileStream<>(inputStream, tweetDatumReader);

        assert dataFileReader.hasNext();
        return dataFileReader.next();
    }
}
