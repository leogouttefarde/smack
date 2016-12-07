import java.io.IOException;

//How to use : 
//Start up a kafka cluster on localhost, create a topic named test, and run the ConsumerTest and the ProducerTest in this order.
//TODO : use on distant servers
public class TestProducerMain
{
	public static void main(String[] args) throws IOException {
	     	ProducerTest testProd = new ProducerTest();
	     	testProd.produce();
	}
}
