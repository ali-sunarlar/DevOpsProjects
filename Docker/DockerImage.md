## Docker nedir ve container'dan farki nedir

Docker Image, birden cok katmanda olusan ve Docker container'da islem yapmak icin olusturulmus dosyalardir.

Container'lar yazilabilir katmana sahip dosyalarken, image'lar sadece okunabilir dosyalardir.

list

```
docker image ls
```

download image

```
docker image pull python
```

### personal image download

docker image pull docker.io/alisunarlar/helloworld

### docker run alisunarlar/helloworld

docker container run -d 8080:80 alisunarlar/helloworld

### busy iceren image'lar

docker search busy

### dockerhub uzerindeki image'lar icin

docker search alisunarlar

### detaylarina bakma

docker image python:latest

### docker image silme 

docker image rm python:latest

### kullanilmayan tum image'larin silinmesi icin

docker image prune

### container'dan image olusturma icin

docker container commit container-name image-name

docker container commit container-name

### Iamge icin etiketleme islemi

##none tag

docker image tag 

##tag update

docker image tag image-id target-image-name

docker image tag alisunarlar/helloworld alisunarlar/merhabadunya

### history

docker image history alisunarlar/helloworld


### example

docker container run -d -p 7080:80 --name hello-world nginx

docker container exec -it hello-world bash

##in container

##cd /usr/share/nginx/html

##ls

##rm index.html

##echo "HELLO WORLD" >> index.html

docker container commit hello-world alisunarlar/hello-world

docker image ls

docker image push alisunarlar/hello-world




