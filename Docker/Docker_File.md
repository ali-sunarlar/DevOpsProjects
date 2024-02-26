## Dockerfile nedir

Dockerfile, belli bir image goruntusu olusturmak icin var olan tum katmanlarin madde made
aciklandiği ve tum islemlerin detaylica belirtildigi text dosyalaridir.

Dockerfile text dosyalari "YAML" adi verilen insan tarafindan kolayca okunabilen bir dil kullanilarak yazilmaktadir.

https://docs.docker.com/engine/reference/builder

## FROM

Hangi image dosyanin referans alinacagi belirtilir

FROM <image>:tag

FROM python:2.7

FROM centos:lates

FROM microsoft/iis:nanoserver

FROM mcr.microsoft.com/dotnet/framework/aspnet:latest

FROM mcr.microsoft.com/windows/servercore:1607

FROM mcr.microsoft.com/windows/servercore:1703



### RUN

Container icerisinde komut calistirmak icin kullanilir

RUN komut

RUN ["<calistirabilir>","<deger 1>","<deger 2>"]

RUN apt-get install -y vim

RUN mkdir /app && cd /app

RUN ["sudo", "-U" "ali","java",...]

RUN apt-get update && apt-get install -y nginx

RUN ["powershell","c:/scipt.ps"]

RUN echo "Hello World - Dockerfile">C:\inetpub\wwwroot\index.html

RUN mkdir -p /app


### ADD

Container icerisine disaridan ve internet uzerinden data kopyalamasi yapmak icin kullanilir

ADD kaynak-dosya hedef-dosya

ADD info.txt /data/proje/

ADD ["./webfile/","/var/html/aaa"]

ADD [--chown=<user>:<group>]<src>...<dest>

ADD --chown=55:muhasebe app /proje1/

ADD test. c:\temp\

ADD http://example.com/sample.txt /data/

ADD http://python.org/ftp/python/3.5.1/python-5.3.1.exe /temp/python-3.5.1.exe

ADD ./requirements.txt /app/


### COPY

COPY <kaynak> <hedef>

COPY [--chown=<user>:<group>] <src>...<dest>

COPY --chown=10:11 app /proje1

COPY pack* /mydir/proje2

COPY html /var/www/hmtl

COPY ./web /app/web

COPY config.txt C:\app\

COPY source C:\data\sqlite

COPY ./requirements.txt /app/



### WORKDIR

Container icerisinde calisma dizini olusturmak-belirlemek icin kullanilir

WORKDIR <path>

WORKKDIR /app

WORKDIR $DIRPATH/$DIRNAME

WORKDIR C:\proje1

WORKDIR C:\app\bin

### VOLUME

Container icerisine kalici depolama alani eklemek icin kullanilir

VOLUME ["<mounpoint>"]

VOLUME <mountpoint>

VOLUME /depo

VOLUME ["/var/log/"]

VOLUME C:\depo

VOLUME /storage

### EXPOSE

container belirtilen port uzerinden talepleri dinler

EXPOSE [<port>/<protocol>...]

EXPOSE 8080

EXPOSE 80/udp

### lABEL

Image sahibi veya farkli meta data detayi eklemek icin kullanilir

LABEL <key>=<value> <key>=<value>

LABEL version="1.0"

LABEL Developer <alisunarlar@gmail.com>

LABEL Student <alisunarlar@gmail.com>


### USER

USER <user> [:<group>]

USER ali[:IT]

USER username



