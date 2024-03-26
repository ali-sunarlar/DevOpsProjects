Container'lar Docker Host uzerinde herhangi bir durum bilgisi tutmadan calisir ve container silinince icerisinde ki herseyde otomatik olarak silinmektedir.

Container icerisine kalici depolama alani eklemek icin kullanilir

default olarak /var/lib/Docker ve C:\ProgramData\Docker altında bulunur

Container silinse dahi Docker volume icerisinde ki datalar saklanmaya devam eder

Docker volume icerisindeki datalar container arasinda paylasilavilir ve kullanilabilir

Data volume icerisinde degisiklikler dogrudan yapilabilir

Image guncellemesi yapildiginda data volume icerisindeki datalarda degisiklik yapilmaz

Docker volume icerisindeki datalar tasinabilir ve yedeklenebilir

Docker volume containerlarin boyutunu artirmaz

İki tipi vardir

Data Volume 

Data volume baglama yonteminde, colume tanimlamasi yapildiktan sonra, container baglama islemi yapilmaktadir.

Bind mounting

Bind mounting tanimlamasinda ise, Host üzerinde olusturulan herhangi bir dosya yolu veya storage'den baglanmak istenen path bilgisi container icerisine baglanarak kullanilmaktadir.

isim vermeden create edildiginde otomatik isim atanir
```sh
root@ubuntu2:~# docker volume create
b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
root@ubuntu2:~# docker volume ls
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
root@ubuntu2:~# docker volume ls
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
local     depo
```

ayrintili bilgi ve default path'de herhangi dosya ve klasör gözükmemektedir.

```sh
root@ubuntu2:~# docker volume inspect depo
[
    {
        "CreatedAt": "2024-03-24T16:03:15Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/depo/_data",
        "Name": "depo",
        "Options": null,
        "Scope": "local"
    }
]
root@ubuntu2:~# ls -l /var/lib/docker/volumes/depo/_data
total 0
```

klasör ve dosya oluşturalim daha sonra bir container oluşturup volume baglama islemi yapalim. Kontrol edildigin baglanan path'de folder'ı görebiliyoruz.
```sh
root@ubuntu2:~# cd /var/lib/docker/volumes/depo/_data
root@ubuntu2:/var/lib/docker/volumes/depo/_data# mkdir webserver1files
root@ubuntu2:/var/lib/docker/volumes/depo/_data# cd webserver1files/
root@ubuntu2:/var/lib/docker/volumes/depo/_data/webserver1files# echo "Hello World" >> Index.html
#host üzerinde oluşturdugumuz dosyayi container uzerinden goruntuleyebildik
root@ubuntu2:/var/lib/docker/volumes/depo/_data/webserver1files# ls -l
total 4
-rw-r--r-- 1 root root 12 Mar 24 16:06 Index.html
root@ubuntu2:~# docker container run --name volumetest1 -d --volume depo:/depo nginx
f03dca4e296a68eac36e055b4ace14be4afc406ca31ceb6b9d4243ec77415422
root@ubuntu2:~# docker container exec -it volumetest1 ls -l /depo
total 4
drwxr-xr-x 2 root root 4096 Mar 24 16:06 webserver1files
root@ubuntu2:~# docker container exec -it volumetest1 bash
root@f03dca4e296a:/# cd /depo
root@f03dca4e296a:/depo# cd webserver1files/
#test icin dosya olusturuyoruz
root@f03dca4e296a:/depo/webserver1files# echo "Test">>data1.txt
root@f03dca4e296a:/depo/webserver1files# ls -l
total 8
-rw-r--r-- 1 root root 12 Mar 24 16:06 Index.html
-rw-r--r-- 1 root root  5 Mar 24 16:11 data1.txt
#host üzerinden oluşturulan dosyayi gorebiliyoruz
root@ubuntu2:~# ls -l /var/lib/docker/volumes/depo/_data/webserver1files/
total 8
-rw-r--r-- 1 root root 12 Mar 24 16:06 Index.html
-rw-r--r-- 1 root root  5 Mar 24 16:11 data1.txt
```


container olusturulurken volume create edilmesi

```sh
root@ubuntu2:~# docker volume ls
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
local     depo
root@ubuntu2:~# docker container run --name volumetest2 -d --volume depo-test2:/depo-test2 nginx sleep 30m
75ea8b7fa824bd54ceddcfba686db58404015a5648fd6f607b333d27dd86acb7
root@ubuntu2:~# docker volume ls
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
local     depo
local     depo-test2
root@ubuntu2:~# docker volume inspect depo-test2
[
    {
        "CreatedAt": "2024-03-24T16:21:17Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/depo-test2/_data",
        "Name": "depo-test2",
        "Options": null,
        "Scope": "local"
    }
]

```

Bind Volume


```sh
root@ubuntu2:~# docker container run -d --name depobagla2 --volume $(pwd)/ortakpaylasim:/depo nginx sleep 30m
5312ba50eaebf0e8eed4a21f25f7a6a583242ffc7e008f70005593a3d27522f6
root@ubuntu2:~# docker container exec -it depobagla2 bash
root@5312ba50eaeb:/# ls -l /depo
total 0
-rw-r--r-- 1 root root 0 Mar 24 16:51 test1.txt
root@5312ba50eaeb:/# cd /depo
root@5312ba50eaeb:/depo# touch test2.txt
root@5312ba50eaeb:/depo# exit
exit
root@ubuntu2:~# ls -l ortakpaylasim/
total 0
-rw-r--r-- 1 root root 0 Mar 24 16:51 test1.txt
-rw-r--r-- 1 root root 0 Mar 24 16:56 test2.txt
#Sadece okunabilir volume baglama
root@ubuntu2:~# docker container run -d --name depobagla3 --volume $(pwd)/ortakpaylasim:/depo:ro nginx sleep 30m
bd7e2ee665c16c09243be6900ba53c9755ea54045f634e8077f9d13522034792
root@ubuntu2:~# docker container exec -it depobaglama3 bash
Error response from daemon: No such container: depobaglama3
root@ubuntu2:~# docker container exec -it depobagla3 bash
root@bd7e2ee665c1:/# cd /depo
root@bd7e2ee665c1:/depo# rm -rf test
test1.txt  test2.txt
root@bd7e2ee665c1:/depo# rm -rf test
test1.txt  test2.txt
root@bd7e2ee665c1:/depo# rm -rf test1.txt 
rm: cannot remove 'test1.txt': Read-only file system
root@bd7e2ee665c1:/depo# mkdir testfolder
mkdir: cannot create directory 'testfolder': Read-only file system
```


Docker file Volume tanimlamalari

```sh
root@ubuntu2:~# mkdir volumedockerfile
root@ubuntu2:~# cd volumedockerfile/
root@ubuntu2:~/volumedockerfile# vi Dockerfile
```

```dockerfile
FROM alpine
VOLUME /mountpointdemo
```

Aynı dizindeki Dockerfile'dan image create edilmesi
```sh
root@ubuntu2:~/volumedockerfile# docker image build -t mount-point-image .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM alpine
 ---> 05455a08881e
Step 2/2 : VOLUME /mountpointdemo
 ---> Running in 3267dd155240
Removing intermediate container 3267dd155240
 ---> 9a1a17d32894
Successfully built 9a1a17d32894
Successfully tagged mount-point-image:latest
```

image'ın ayrıntılarini kontrol etme
```sh
root@ubuntu2:~/volumedockerfile# docker image inspect mount-point-image
[
    {
        "Id": "sha256:9a1a17d328941c11373fd9c93104b216e3795f1a7ce2c88f8311441f4c8eb7c4",
        "RepoTags": [
            "mount-point-image:latest"
        ],
        "RepoDigests": [],
        "Parent": "sha256:05455a08881ea9cf0e752bc48e61bbd71a34c029bb13df01e40e3e70e0d007bd",
        "Comment": "",
        "Created": "2024-03-24T17:15:27.614349117Z",
        "Container": "3267dd1552405b0753bae47b4aa68c61186f87c1976eeba188467c547b0eb3ba",
.
.
.
            ],
            "Image": "sha256:05455a08881ea9cf0e752bc48e61bbd71a34c029bb13df01e40e3e70e0d007bd",
            "Volumes": {
                "/mountpointdemo": {}
.
.
.
```

Suanki volume'ler gorunmektedir. Container create edildikten sonra volume oluşturulduğu görülmektedir.
```sh
root@ubuntu2:~/volumedockerfile# docker volume ls
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
local     depo
local     depo-test2
DRIVER    VOLUME NAME
local     3dfc3248bd8d1397afaf28f347a2b037fca55c6481b7e1c901568ecd4564c306
local     69eaa353b7a103882beb995a7329da9c9cf1769c449107b1fb34fb587ae928fd
local     b3000375e848bfb01452d9838f1aea91e97d7d8333c56fdcc381476fa027b84e
local     depo
local     depo-test2
```
