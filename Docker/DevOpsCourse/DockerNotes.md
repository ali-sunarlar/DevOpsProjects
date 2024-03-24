# Dockerfile
#---------
#container image yaratmak icin kullanildigimiz docker bilesenidir.
#image cekme

Ornek Dockerfile

```dockerfile
FROM ubuntu:latest 
#RUN container'da yapilmak istenen aksiyonlarda kullanilir
RUN apt-get update -y
RUN apt install nano -y
RUN apt install nginx -y
RUN systemctl start nginx -y
RUN systemctl enable nginx -y
#container'a dosya kopyalamak icin
COPY index.html /usr/share/nginx/html/
#Container icerisine disaridan ve internet uzerinden data kopyalamasi yapmak icin kullanilir
ADD info.txt /data/proje/
ADD http://python.org/ftp/python/3.5.1/python-5.3.1.exe /temp/python-3.5.1.exe
#default çalışma path'i belirtilir. Container icerisinde calisma dizini olusturmak-belirlemek icin kullanilir
WORKDIR /opt/app
#container belirtilen port uzerinden talepleri dinler
EXPOSE 8080/tcp
```


example MYSQL
```dockerfile
FROM mysql:latest
ENV MYSQL_ROOT_PASSWORD=Password
ENV MYSQL_DATABASE=mydb
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWOR=Password
```

```sh
docker image build -t alisunarlar/devops:mysqlv1 .
```

```dockerfile
FROM nginx:latest
WORKDIR /usr/share/
COPY index.html .
COPY style.css css/
COPY script.js js/
CMD ["nginx", "-g","deamon off;"]
```


```sh
docker image build -t alisunarlar/devops:nginxv1 .
docker run --name webserver -d alisunarlar/devops:nginxv1

```

--restart always hata alınırsa otomatik restart eder. Registry:2 ise ücretsiz olarak kullanabileceğimiz repo registry container'ıdır

```sh
docker run -d -p 5000:5000 --restart always registry:2

docker pull alpine:3.6

docker tag alpine:3.6 localhost:5000/alpine:3.6

root@ubuntu2:/home/user# docker push localhost:5000/alpine:3.6
The push refers to repository [localhost:5000/alpine]
721384ec99e5: Pushed
3.6: digest: sha256:36c3a913e62f77a82582eb7ce30d255f805c3d1e11d58e1f805e14d33c2bc5a5 size: 528

root@ubuntu2:/home/user# docker image ls
REPOSITORY              TAG       IMAGE ID       CREATED       SIZE
registry                2         9363667f8aec   7 days ago    25.4MB
localhost:5000/alpine   3.6       43773d1dba76   5 years ago   4.03MB
alpine                  3.6       43773d1dba76   5 years ago   4.03MB

root@ubuntu2:/home/user# curl http://localhost:5000/v2/_catalog
{"repositories":["alpine"]}
```


## Docker Network

Docker network list. Farklı network'ler birbirleriyle haberlesemez

```sh
root@ubuntu2:/home/user# docker network ls
NETWORK ID     NAME             DRIVER    SCOPE
a0ae22b7047b   bridge           bridge    local
e2b81baf2605   host             host      local
bde5689c3352   none             null      local
```

bridge network default olarak 172.17.0.0/16 networ'ünden yapılır.

```sh
root@ubuntu2:/home/user# docker inspect bridge
[
    {
        "Name": "bridge",
        "Id": "a0ae22b7047bfd415c96fc5664be63f75064e4ac119145c5f61bb50782b14939",
        "Created": "2024-03-19T08:30:10.064520567Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

-d driver anlamında. bridger driver kullanmak istedigimiz belirtiliyor

```sh
root@ubuntu2:/home/user# docker network create -d bridge mybridgenetwork
0a7e832b304d20e2018d8b5147a0beebbfd95c71414852156025a5274a19d3dc
root@ubuntu2:/home/user# docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
a0ae22b7047b   bridge            bridge    local
e2b81baf2605   host              host      local
0a7e832b304d   mybridgenetwork   bridge    local
bde5689c3352   none              null      local
```

olusturdugumuz networku kullanarak container ayaga kaldirma

```sh
root@ubuntu2:/home/user# docker run --network mybridgenetwork -d nginx
24409f2551d75df516c99f436e8b12e5ffbbd47d12e0efee6a403c04376e3f70
```

özel subnet ile network create etme

```sh
root@ubuntu2:~# docker network create --subnet=192.168.3.0/16 --gateway=192.168.3.1 mynetwork
64579b02f2e97965eae31eaf938e9e8e17f43d94b32f198d0a45b6696fbdc5b5
root@ubuntu2:~# docker inspect mynetwork
[
    {
        "Name": "mynetwork",
        "Id": "64579b02f2e97965eae31eaf938e9e8e17f43d94b32f198d0a45b6696fbdc5b5",
        "Created": "2024-03-24T08:17:33.630903124Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.3.0/16",
                    "Gateway": "192.168.3.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]

#docker container create

root@ubuntu2:~# docker run -d --name webserver --network mynetwork -p 8007:80 nginx
d85cc683ed13be624eeb54c8fe303ebcc0c4c3f772aee1bb813d458075c2631c
root@ubuntu2:~# docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                   NAMES
d85cc683ed13   nginx     "/docker-entrypoint.…"   8 seconds ago   Up 6 seconds   0.0.0.0:8007->80/tcp, :::8007->80/tcp   webserver
24409f2551d7   nginx     "/docker-entrypoint.…"   16 hours ago    Up 16 hours    80/tcp                                  hardcore_poitras

root@ubuntu2:~# curl localhost:8007
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```









