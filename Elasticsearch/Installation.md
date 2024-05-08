#Install Requirement
apt update
apt install -y default-jre default-jdk
apt install -y apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common

#Nginx Kurulumu
sudo apt-get install nginx

#Elastic Search Kurulumu
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update 
apt-get install elasticsearch=7.17.4

vi /etc/elasticsearch/elasticsearch.yml
network.host: SunucuIP
http.port: 9200
discovery.type: single-node
xpack.security.enabled: true


sudo systemctl enable elasticsearch.service 
sudo systemctl start elasticsearch.service

#Install Kibana
sudo apt-get install kibana

#Conf Kibana
vi /etc/kibana/kibana.yml
server.port: 5601
server.host: SunucuIP
elasticsearch.hosts: "elasticserverip:port"
elasticsearch.username: "elastic"
elasticsearch.password: "elasticuserpass"