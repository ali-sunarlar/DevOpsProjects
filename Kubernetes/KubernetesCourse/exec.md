Pod içerisinde komut çalıştırma yazım şekli

kubectl exec (POD | TYPE/NAME) [-c CONTAINER] [flags] -- COMMAND [args...] [options]

my-web isimli pod üzerinde date komutunu çalıştırıp çıktıyı ekrana yazdırma

kubectl exec my-web -- date

my-web isimli pod üzerinde ls / (root dizini listele)komutunu çalıştırıp çıktıyı ekrana yazdırma

kubectl exec my-web -- ls /

my-web isimli pod üzerinde env komutunu çalıştırıp çıktıyı ekrana yazdırma

kubectl exec my-web -- env

my-web isimli pod komut satırına bağlanma(bash veya sh kabuğuna)

kubectl exec --stdin --tty my-web -- /bin/bash

exec-test-ubuntu isimli pod komut satırına bağlanma (--stdin –tty kısaltması -it)

kubectl exec -it exec-test-ubuntu -- bash

demo-code isimli pod içerisinde “node my-script.js “ komutunu çalıştırıp çıktıyı ekrana yazdırma

kubectl exec -it demo-code -- node my-script.js

hazelcast image’ını kullanan pod için environment variable tanımlayarak pod oluşturma

kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster"

mariadb image’ını kullanan pod için environment variable tanımlayarak pod oluşturma

kubectl run my-db --image=mariadb --env=MYSQL_ROOT_PASSWORD='onetwouc12'

my-db isimli pod içerisinde çalışan database uygulamasına komut kullanarak doğrudan bağlanma

kubectl exec -it my-db -- mariadb -uroot -p

k8s-mariadb isimli pod üzerinde komut çalıştırıp ekrana çıktıyı listeleme

kubectl exec k8s-mariadb -- ls /var/lib/mysql/

kubectl exec webpod-84f96d465f-4bf9q ls /usr/share/nginx/html/

Python imageını kullanan pod oluşturup içerisinde bağlanma, çıkış yapıldığında podun silinmesi

kubectl run pythoncode -it --rm --image=python

Centos imageını kullanan pod oluşturup terminaline bağlanma, çıkış yapıldığında podun silinmesi

kubectl run tmp-shell --restart=Never --rm -i --tty --image=centos -- /bin/bash

Çoklu kontainer olurulmuş my-web pod’u içerisinde ki wb1 containerın root dizinin listelenmesi

kubectl exec my-web -c wb1 -- ls /

Çoklu kontainer olurulmuş my-web pod’u içerisinde ki main-app containerın komut satırına bağlanma

kubectl exec -i -t my-pod --container main-app -- /bin/bash
