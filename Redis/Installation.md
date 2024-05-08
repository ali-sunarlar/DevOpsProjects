#Requirement Package Install
apt install -y libc
apt install -y make
apt install -y libc
apt install -y lsb-release curl gpg
apt install -y tcl tk
apt install -y gcc
apt update
#Download Redis Package
cd /tmp
wget https://download.redis.io/releases/redis-7.0.5.tar.gz 
#Extract Redis Package
tar xvzf redis-7.0.5.tar.gz redis-7.0.5/
cd /tmp/redis-7.0.5

#Install Redis Server
make
make install
redis-server


#memory conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#Add redis user
sudo adduser --system --group --no-create-home redis

#Create Redis Directory & Copy redis Conf File
mkdir -p /etc/redis
cp /tmp/redis-7.0.5/redis.conf /etc/redis/redis.conf
mkdir /var/lib/redis
chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

#Create Redis Server Service
vi /etc/systemd/system/redis-server.service

#redis-server.service file içine yazılacak komutlar
[Unit]
Description=Redis In-Memory Data Store
After=network.target
[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always
[Install]
WantedBy=multi-user.target

#Redis server'a sunucu ip nizi bind edin.
vi /etc/redis/redis.conf
#dosya içinde bind 127.0.0.1 satırını bulunuz
bind 127.0.0.1 --> bind 127.0.0.1 192.168.1.10
#protected mod kapatma
protected-mode yes --> protected-mode no

#Redis Server Enable etme, başlatma ve durum kontrolü
systemctl enable redis-server.service
systemctl start redis-server.service
systemctl status redis-server.service

lsof -i -P -n | grep LISTEN

#Redis Cli Test etme
redis-cli
127.0.0.1:6379> ping
PONG
#Pong sonucunu görüyor isen redis ayakta demektir.