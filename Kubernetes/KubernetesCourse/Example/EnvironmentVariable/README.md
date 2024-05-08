## 🧑 Ders: Environment Variable


### 📗Bu bölümde Environment Variable Yönetim işlemlerini bulacaksınız📗(murataksu.net)

#### Nedir ?
***
```
Envieronment Variable, POD içerisinde ortam değişkenleri tanımlamak için kullanılmaktadır.

Örnek:
BACKEND_SRV_SERVICE_HOST = 10.147.252.185
BACKEND_SRV_SERVICE_PORT = 5000
KUBERNETES_RO_SERVICE_HOST = 10.147.240.1
KUBERNETES_RO_SERVICE_PORT = 80
KUBERNETES_SERVICE_HOST = 10.147.240.2
KUBERNETES_SERVICE_PORT = 443
KUBE_DNS_SERVICE_HOST = 10.147.240.10
KUBE_DNS_SERVICE_PORT = 53
```
***
#### Pod Oluştururken ENV bilgisi ekleme
```
kubectl run nginx-env --image=nginx --restart=Always --env=KUBERNETES_SERVICE_PORT="443"
```
***
#### Çalışan POD üzerindeki ENV bilgilerini görüntüleme
```
kubectl exec nginx-env -- printenv

kubectl exec podenvironment -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=podenvironment
MYSQL_USER=admin
MYSQL_DATABASE=test-db
MYSQL_ROOT_PASSWORD=onetwothree!
MYSQL_HOST=mysql-service
MYSQL_TCP_PORT=3306
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
GOSU_VERSION=1.12
MYSQL_MAJOR=5.6
MYSQL_VERSION=5.6.51-1debian9
HOME=/root
```
***
#### YAML üzerinden ENV bilgisi ekleme
```
    env:
    - name: PMA_HOST
      value: mysql
    - name: PMA_PORT
      value: "3306"
```

