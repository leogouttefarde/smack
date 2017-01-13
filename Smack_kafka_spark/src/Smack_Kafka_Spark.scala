import org.apache.kafka.clients.producer.{ KafkaProducer, ProducerConfig, ProducerRecord }
import org.apache.spark.streaming._
import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.SparkSession
import java.util.HashMap

object Smack_Kafka_Spark extends App{
  def main(args: Array[String]) {
    val kafkaBrokers = "localhost:2181"

    val kafkaOpTopic = "test"
    val props = new HashMap[String, Object]()
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, kafkaBrokers)
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
      "org.apache.kafka.common.serialization.StringSerializer")

    val producer = new KafkaProducer[String, String](props)

    var spark: SparkSession = null
    val textFile: RDD[String] = spark.sparkContext.textFile("dataset.txt")
    textFile.foreach(record => {
      val data = record.toString
      val message = new ProducerRecord[String, String](kafkaOpTopic, null, data)
      producer.send(message)
    })
    producer.close()

  }
}