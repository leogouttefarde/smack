
//Don't forget to launch the consumer before the producer
import org.apache.kafka.clients.consumer.{ KafkaConsumer, ConsumerConfig, ConsumerRecord }
import org.apache.kafka.common.TopicPartition
import java.util.HashMap
import java.util.Collection
import java.util.List
import java.util.{ Arrays, Properties }
import scala.collection.JavaConversions._
import scala.util.Random
import java.util.{ Collections, Properties }
import org.apache.spark.sql.SparkSession
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.sql._

object ConsumerToSpark {
  def main(args: Array[String]): Unit = {
    
    val kafkaBrokers = "localhost:9092"

    val topic = "test"

    /******* Config Consumer *******/
    val props = new HashMap[String, Object]()
    props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBrokers)
    props.put(ConsumerConfig.GROUP_ID_CONFIG, "test" + System.currentTimeMillis())
    props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false")
    props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest")
    props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer")
    props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "org.apache.kafka.common.serialization.StringDeserializer")
    props.put(ConsumerConfig.FETCH_MAX_WAIT_MS_CONFIG, "0") //ensure we have no temporal batching

    /******* Receive records *******/
    val consumer = new KafkaConsumer[String, String](props)
    consumer.subscribe(Collections.singletonList(topic))

    val spark: SparkSession = SparkSession.builder()
      .appName("Smack_Kafka_Spark")
      .master("local[*]")
      .getOrCreate()

    var liste = scala.collection.immutable.List[String]();

    while (true) {
      /* Store records in a list */
      val records = consumer.poll(1000)

      for (record <- records) {

        liste = record.value() :: liste // to append a new record to the list

      }

      /* Process records here */
      val lines = liste.map(line => line)

      //println("lines:"+lines);

      val myrdd = spark.sparkContext.makeRDD(lines);

      myrdd.collect().foreach(println)
      
      //I didn't close the consumer so as to allow the consumer to receive any new records.

    }
  }
}