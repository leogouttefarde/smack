
sudo kill $(ps auwx | grep cassandra | awk '{print $2}')
rm -rf ~/apache-cassandra-3.9/data/*

echo "Cassandra killed on $(hostname)"
