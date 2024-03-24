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

















