
#Koytener Başlat / Duraklar / Sil / Listele Komut İşlemleri

#run
docker container run hello-world
docker container run alpine
docker container run alpine:3.9
docker container run python:2
docker container ls -a


docker container run --help

docker container run --name proje1 python:2

#info
docker info

docker container ls

docker container ls --help

docker container ls -all

#sadece id'ler goruntulenir
docker container ls --all --quiet

docker container run -d -p 4000:4000 docs/docker.github.io

docker container rename jolly_hopper dockerweb

docker container pause dockerweb

docker container stop dockerweb

docker container start dockerweb

docker container restart dockerweb

docker container rm --help

 docker container rm f8bcecb2c75c

docker container rm f8

docker container rm stupefied_tesla --force

#topluca silme
docker container rm 12 b4 0e

docker container rm $(docker container ls -a -q)

#durmus olan container'lari siler
docker container prune

#Linux Nginx / Windows IIS Web Server İncelmesi

#publish yayin yapilacagi port belirtilir. kisaltmasi -p
#-P random belirlenir
docker container run --publish 8080:80 nginx
docker container run -p 8080:80 nginx

# 8080 portu host portu
# 80 container portu

#detach koyteynerı arka planda calistirir. kisaltmasi -d
docker container run --publish 8080:80 --detacth nginx
docker container run --publish 8080:80 -d nginx

docker pull nanoserver/iis
docker container run -p 5080:80 -d nanoserver/iis


#SSH olmadan Container'a Baglanip Islem Yapma

docker container run centos

#--interactive Standard Input Acik tutar ve erisime izin verir. terminale erismek icin
# kisaltmasi -i 
#--tty konteyner terminaline erisim saglar
# kisaltmasi -t
docker container run --interactive --tty
docker container run -i -t

#bash konteyner icerisindeki isletim sistemi kabuguna baglan
docker container run --interactive --tty centos bash

# /bin/bash konteyner icerisindeki isletim sistemi kabuguna baglan --kabuk path yolu
docker container run --interactive --tty centos /bin/bash

docker container run --interactive --tty python:3 bash
docker container run --interactive --tty python:3 python
docker container run --interactive --tty python:3 python --help

docker pull mcr.microsoft.com/windows/servercore/iis
docker container run --interactive --tty mcr.microsoft.com/windows/nanoserver:ltsc2022

# --rm konteynerdan cikis yapildiginda konteyneri siler
docker container run --rm -it python:3

docker container run --interactive --tty --name OpSy1 centos:latest

docker container run --name OpSy2 --interactive --tty alpine

#python -V calistirilir.
docker container run -it python:3 python -V

docker container run -it mcr.microsoft.com/dotnet/core/sdk
docker container run -it mcr.microsoft.com/dotnet/core/sdk bash

docker run --rm mcr.microsoft.com/dotnet/samples
docker run -it --rm -p 8000:8080 --name aspnetcore_sample mcr.microsoft.com/dotnet/samples:aspnetapp

docker container run -it openjdk:7 java --version

#30 dakika boyunca ayakta tutmak icin
docker container run -d --name OpSy3 centos sleep 30m

#html5 web sayfası ile masaustune ulasabilme
docker container run -p 6080:80 -d dorowu/ubuntu-desktop-lxde-vnc

#SSH olmadan Container'a Baglanip Islem Yapma 2

#calisan veya var olan container'a baglanmak icin

docker container exec -it containerid /bin/bash
docker container exec -it containername
docker container exec -it linuxcontainer

docker container exec -it windowscontainer cmd
docker container exec -it windowscontainer powershell

docker container exec -it linuxcontainer mkdir webdosyalari
docker container exec -it linuxcontainer yum install -y vim

docker container exec -it windowscontainer powershell Get-WindowsFeature
docker container exec -it windowscontainer powershell add-WindowsFeature dns
docker container exec -it windowscontainer powershell add-WindowsFeature dns

docker container run -d --name centoscontainer centos sleep 30m
docker container exec -it centoscontainer bash
docker container exec -it centoscontainer mkdir app2
docker container exec -it centoscontainer yum install -y nginx

docker container exec -it centoscontainer /bin/bash ./tmp/script

docker container run -it --name server1 mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd
docker container run -it --name server1 mcr.microsoft.com/windows/nanoserver:ltsc2022 ping localhost -t


#Local'den Konteyner'a - Konteyner'dan Local'e Veri Aktarma

#Host'dan Konteyner'a Veri Kopyalama
docker container cp host dosya yolu konteyner:hedefyol
docker container cp host $(pwd) konteyner:$(pwd)

#Konteyner'dan Host'a veri kopyalama
docker container cp konteyner:dosya yolu host hedef yol

docker container run --name dkopyala -d alpine sleep 30m
docker container cp /home/user/deneme.txt dkopyala:/tmp
docker container cp /home/user/index.html dkopyala:/tmp
docker container exec dkopyala ls -l /tmp

docker container cp dkopyala:/tmp/deneme.txt /home/user/deneme1.txt

docker container run --name winkopyala2 -dp 3330:80 mcr.microsoft.com/windows/nanoserver:ltsc2022
docker container cp install-docker-ce.ps1 winkopyala2:install-docker-ce.ps1
docker container cp winkopyala2:install-docker-ce.ps1 install-docker-ce1.ps1


# --volume voluma baglamak icin
# kisaltmasi -v

docker container run --volume depo:/tmp/ centos

docker container run --volume c:data:c:/app mcr.microsoft.com/windows/nanoserver:ltsc2022

docker container run --workdir c:\app mcr.microsoft.com/windows/nanoserver:ltsc2022
docker container run --name winfilebagla -d --volume C:\data:C:\webdosyalari --workdir C:\webdosyalari mcr.microsoft.com/windows/nanoserver:ltsc2022

docker container run --name linfilebagla -d -v /home/root:/tmp/root nginx


#Windows Yönetim Araçlarıyla Konteyner'lari Yönetme
docker container run --name iismanage -d -p 8090:80 mcr.microsoft.com/windows/servercore/iis
docker container exec -it iismanage powershell c:\Temp\pscode.ps1

#detayli bilgi
docker container inspect iismanage

docker container run --name servermanage -d mcr.microsoft.com/windows/servercore:ltsc2022 ping localhost -t
docker container cp pssrvcode1.ps1 servermanage:c:\temp\pssrvcode.ps1

#Container windows makinaya güvenli olarak girilir

Set-Item WSMan:\localhost\Client\TrustedHosts "172.30.93.118" -Concatenate -Force
Set-Item WSMan:\localhost\Client\TrustedHosts "92d89b3f4815" -Concatenate -Force


#Coklu Konteyner Yönetimi

#--env koyteyner icerisindeki uygulamaya ortam degiskeni atamak icin kullanilmaktadir.
# kisaltmasi -e
docker container run --name mariadb1 -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD='PasswOrd!' mariadb
docker container run --name mariadb2 -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD='PasswOrd!' mariadb
docker container run --name mssqldb1 -d -p 1433:1433 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Passw0rd!' mcr.microsoft.com/mssql/server:2022-latest
docker container run --name mssqldb2 -d -p 1434:1433 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Passw0rd!' mcr.microsoft.com/mssql/server:2022-latest
docker container run -d -p 1010:80 mcr.microsoft.com/dotnet/samples:aspnetapp
docker container run -d -p 2020:80 httpd
docker container run -d -p 3030:80 nginx

docker container exec -it mssqldb1 /opt/mssql-tools/bin/sqlcmd -s localhost -U SA -P "Passw0rd!"
docker container exec -it mariadb1 mariadb -u root -p bash























