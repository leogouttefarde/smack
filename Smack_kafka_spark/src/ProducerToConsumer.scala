import org.apache.kafka.clients.producer.{ KafkaProducer, ProducerConfig, ProducerRecord }
import org.apache.kafka.clients.consumer.{ KafkaConsumer, ConsumerConfig, ConsumerRecord }
import org.apache.spark.streaming._
import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.SparkSession
import java.util.HashMap

object ProducerToConsumer {
  def main(args: Array[String]): Unit = {
    
    val kafkaBrokers = "localhost:9092"
    
    val topic = "test"
    
     /******* Config Producer *******/
    val props = new HashMap[String, Object]()
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBrokers)
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    props.put("group.id", "test");

    /******* Send Records *******/
    val producer = new KafkaProducer[String, String](props)

    val spark: SparkSession = SparkSession.builder()
      .appName("Smack_Kafka_Spark")
      .master("local[*]")
      .getOrCreate()

    val textFile: RDD[String] = spark.sparkContext.textFile("Dataset.txt")
    textFile.foreachPartition((partisions: Iterator[String]) => {
      val producer: KafkaProducer[String, String] = new KafkaProducer[String, String](props)
      partisions.foreach((line: String) => {
        try {
          producer.send(new ProducerRecord[String, String](topic, line))
        } catch {
          case ex: Exception => {

          }
        }
      })
      producer.close()
    })

  }
}