## Dockerfile nedir

Dockerfile, belli bir image goruntusu olusturmak icin var olan tum katmanlarin madde made
aciklandiği ve tum islemlerin detaylica belirtildigi text dosyalaridir.

Dockerfile text dosyalari "YAML" adi verilen insan tarafindan kolayca okunabilen bir dil kullanilarak yazilmaktadir.

https://docs.docker.com/engine/reference/builder

## FROM

Hangi image dosyanin referans alinacagi belirtilir

```dockerfile
FROM <image>:tag

FROM python:2.7

FROM centos:latest

FROM microsoft/iis:nanoserver

FROM mcr.microsoft.com/dotnet/framework/aspnet:latest

FROM mcr.microsoft.com/windows/servercore:1607

FROM mcr.microsoft.com/windows/servercore:1703
```


### RUN

Container icerisinde komut calistirmak icin kullanilir

RUN komut

```dockerfile
RUN ["<calistirabilir>","<deger 1>","<deger 2>"]

RUN apt-get install -y vim

RUN mkdir /app && cd /app

RUN ["sudo", "-U" "ali","java",...]

RUN apt-get update && apt-get install -y nginx

RUN ["powershell","c:/scipt.ps"]

RUN echo "Hello World - Dockerfile">C:\inetpub\wwwroot\index.html

RUN mkdir -p /app
```

### ADD

Container icerisine disaridan ve internet uzerinden data kopyalamasi yapmak icin kullanilir
```dockerfile
ADD kaynak-dosya hedef-dosya

ADD info.txt /data/proje/

ADD ["./webfile/","/var/html/aaa"]

ADD [--chown=<user>:<group>]<src>...<dest>

ADD --chown=55:muhasebe app /proje1/

ADD test. c:\temp\

ADD http://example.com/sample.txt /data/

ADD http://python.org/ftp/python/3.5.1/python-5.3.1.exe /temp/python-3.5.1.exe

ADD ./requirements.txt /app/
```

### COPY

kopyalama
```dockerfile
COPY <kaynak> <hedef>

COPY [--chown=<user>:<group>] <src>...<dest>

COPY --chown=10:11 app /proje1

COPY pack* /mydir/proje2

COPY html /var/www/hmtl

COPY ./web /app/web

COPY config.txt C:\app\

COPY source C:\data\sqlite

COPY ./requirements.txt /app/
```


### WORKDIR

Container icerisinde calisma dizini olusturmak-belirlemek icin kullanilir

```dockerfile
WORKDIR <path>

WORKKDIR /app

WORKDIR $DIRPATH/$DIRNAME

WORKDIR C:\proje1

WORKDIR C:\app\bin
```

### VOLUME

Container icerisine kalici depolama alani eklemek icin kullanilir

```dockerfile
VOLUME ["<mounpoint>"]

VOLUME <mountpoint>

VOLUME /depo

VOLUME ["/var/log/"]

VOLUME C:\depo

VOLUME /storage
```

### EXPOSE

container belirtilen port uzerinden talepleri dinler

```dockerfile
EXPOSE [<port>/<protocol>...]

EXPOSE 8080

EXPOSE 80/udp
```

### lABEL

Image sahibi veya farkli meta data detayi eklemek icin kullanilir

```dockerfile
LABEL <key>=<value> <key>=<value>

LABEL version="1.0"

LABEL Developer <alisunarlar@gmail.com>

LABL Student <alisunarlar@gmail.com>
```

### USER

```dockerfile
USER <user> [:<group>]

USER ali[:IT]

USER username
```

### ENV

Container için ortam değişkenleri tanımlamak için kullanılmaktadır. Key value olarak tanımlanabilir.
```dockerfile
ENV <key> <value>

ENV LOG_DIR /var/log/apache

ENV sifre birikiuc123

ENV APP_PORT 8080
```

### CMD

Container oluşturulduğunda belirliten uygulamayı calıştırmak icin kullanilir
```dockerfile
CMD <komut>
CMD ["executable","param1","param2"]
CMD ["param1","param2"]
CMD ["echo","MerhabaDunya",""]
CMD ["python","demo.py"]
CMD node server.js
CMD ["dotnet","aspdoketnet.dll"]
CMD c:\Apache24\bin\httpd.exe -w
```

### ENTRYPOINT

container olusturuldugunda varsayılan parametreleri tanımlamak ve calistirmak icin kullanilir

```dockerfile
ENTRYPOINT <path>

ENTRYPOINT ["executable","param1","param2"]

ENTRYPOINT ["echo","MerhabaDunya"]

ENTRYPOINT ["node","server.js"]
```

#### CMD ile beraber calistirilmasi

```dockerfile
ENTRYPOINT ["npm"]

CMD ["start"]

ENTRYPOINT ["python"]

CMD ["main.py"]

ENTYPOINT["ping"]

CMD ["8.8.8.8","-c","3"]
```

### Shell ve Exec 

Shell ile Kullanım

<instruction>   <commad>

linux path -->      /bin/sh -c <command>

Windows path -->    cmd /s /C <command>

CMD echo "MerhabaDunya"

RUN apt-get install pytho3 -y

RUN mkdir -p /app

CMD node /web-ping/app.js

Exec ile Kullanim(Onerilen Yazim Sekli)

<instruction>   ["executable","param1","param2",...]

CMD ["/bin/echo","MerhabaDunya"]

RUN ["apt-get","install","python3"]

RUN ["mkdir","-p","/app"]

CMD ["node","/web-ping/app.js"]



### Example

```dockerfile
FROM ubuntu:latest

LABEL Ali Sunarlar <alisunarlar@gmail.com>

RUN apt-get update && apt-get install -y nginx 

WORKDIR- /var/www/html

COPY ..

EXPOSE 80/tcp

CMD ["nginx","- daeamon off"]
```

### Exaple docker image olusturma

Nokta(.) isaretini kullanarak icinde bulundugumuz klasordeki dockerfile dosyasinin derlenmesini saglamaktayiz.

```sh
docker image build --tag hello-dockerfile .
```

/opt/docker gibi docker file'nin tutuldugu dizin belirtilebilir.

```sh
docker image build --tag hello-dockerfile /opt/docker .
```

dockerhub'a gonderilecek sekilde image create etme

```sh
docker image build --tag alisunarlar/hello-dockerfile /opt/docker .
```

--tag kisaltmasi -t 'dir

cache'deki veri cekilerek tekrar image olusturulabilir.

```sh
docker image build  --tag hello-dockerfile-wcache .
```

dockerfile ile olusturulmus image'dan container calistirma

```sh
docker container run -dp 8080:80 hello-dockerfile
```

### .Dockerignore

gitignore ile aynı mantıktadır.


## RUN - CMD - ENTRYPOINT

ENTRYPOINT ornegi 1

```dockerfile
FROM centos:latest

ENTRYPOINT ["/bin/echo"]
```

calıştırılırsa

```sh
docker container run myimage 1 2 3
```

output --> 123 olur

ENTRYPOINT ornegi 2

```dockerfile
FROM centos:latest
ENTRYPOINT ["/bin/echo" , "0"]
```

calıştırılırsa

```sh
docker container run myimage 1 2 3
```

output --> 0123 olur


CMD Ornegi
```dockerfile
FROM centos:latest

ENV isim Ali Sunarlar

CMD
```

sabit olmasini istedigimiz deger ENTRYPOINT icerisine degisken degerleri CMD icerisine yazarak kullanabiliriz
```dockerfile
ENTRYPOINT ["/bin/chamber","exec","production","--"]
CMD ["/bin/service","-d"]
```

Ornek Dockerfile İncelemeleri

Create dockerfile
```dockerfile
FROM ubuntu:latest
FROM apt update && apt install -y cowsay
CMD ["/usr/games/cowsay","Hello from Dockerfile"]
```

Create Image and Run

```sh
docker image build --tag cowsay1 .
docker container run cowsay1
 _______________________
< Hello from Dockerfile >
 -----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

```dockerfile
FROM mcr.microsoft.com/windows/nanoserver:1709
COPY hello.txt C:
CMD ["cmd", "/C", "type C:\\hello.txt"]
```

Create and Run
```sh
docker image build --tag nanoserverhello .
docker container run nanoserverhello
Hello from nanoserver
```

Daha az layer kullanilmasi onerilir.
```dockerfile
FROM alpine:3.7
LABEL By dockerfile <alisunarlar@gmail.com>
RUN apk update && apk add \
    curl \
    git \
    vim \
    wget
```

```dockerfile
FROM mcr.microsoft.com/windows/servercore:1607
COPY pscode.ps1 c:\\pscode1.ps1
CMD ["powershell.exe", "c:\\pscode.ps1"]
```

```dockerfile
FROM mcr.microsoft.com/windows/servercore:1607
LABEL Description="Custom-Windows" Vendor="Microsoft" Version="1"
RUN powershell -Command Install-WindowsFeature Web-server, \
    Web-Asp-Net45, Net-Framework-45-ASPNET, \
    DNS, RSAT-DNS-Server -Verbose
CMD ["ping", "-t","localhost">NULL]
```


```dockerfile
FROM microsoft/iis
RUN powershell -NoProfile -Command Remove-Item --Recurse C:\inetpub\wwwroot\*
COPY . C:\inetpub\wwwroot
EXPOSE 80
```

```dockerfile
FROM ubuntu:16.04
RUN apt-get update \
    && apt-get install -y nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tpm/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf
ADD default /etc/nginx/sites-available/default
EXPOSE 80
CMD ["nginx"]
```

```dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1
WORKDIR /src
COPY src/ .
RUN dotnet restore; dotnet build
CMD ["dotnet","run"]
```

Nodejs
```dockerfile
FROM node:9.4
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY . /app/
ENTRYPOINT [ "npm" ]
CMD [ "start" ]
```

Hello world from C language

```c
#include <stdio.h>
int main (void)
{
    printf("Hello from C language\n");
    return 0;
}
```

```dockerfile
FROM alpine:3.7
RUN apk update && apk add --update alpine-sdk
RUN mkdir /app
WORKDIR /app
COPY ./helloworld /app/
RUN mkdir bin
RUN gcc -Wall merhaba.c -o bin/merhaba
CMD /app/bin/merhaba
```

Create and run
```sh
docker image build --tag helloworldfromc .
docker container run helloworldfromc  
Hello world from C language
```

Multistage Çok katmanlı Dockerfile

Bir önceki oluşturduğumuz image boyutu 178MB

```sh
ocker images
REPOSITORY          TAG       IMAGE ID       CREATED             SIZE
helloworldfromc     latest    81de089c67b7   16 minutes ago      178MB
```

```dockerfile
FROM alpine:3.7 AS build
RUN apk update && apk add --update alpine-sdk
RUN mkdir /app
WORKDIR /app
COPY ./helloworld /app/
RUN mkdir bin
RUN gcc merhaba.c -o bin/merhaba

FROM alpine:3.7
COPY --from=build /app/bin/merhaba /app/merhaba
CMD /app/merhaba
```

boyutun küçüldüğü görülüyor
```sh
docker image ls 
REPOSITORY                  TAG       IMAGE ID       CREATED             SIZE
helloworldfromcmultistage   latest    fc082ab6f883   18 seconds ago      4.22MB
helloworldfromc             latest    81de089c67b7   24 minutes ago      178MB
```


