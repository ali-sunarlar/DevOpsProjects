## 🧑 Ders: Volume

### 📗Bu bölümde emptyDir ve HostPath yönetimi hakkında bilgi bulacaksınız 📗(murataksu.net)

#### Pod içerisine emptyDir volume bağlama
***
```
  volumes:
  - name: cache-volume
    emptyDir: {}
```

Pod'larin hepsi silinirse datalar silinir.

Kısıtlı memory sahip ve cache kullanımı yapan

uygulamalarınız varsa yada pod üzerinde çoklu

konteynerlar arasında dosya paylaşımı yapmak

isterseniz emptrydir volume bunun için oldukça kullanışlıdır 

***
#### Pod içerisine hostPath volume bağlama
```
  volumes:
  - name: data-volume
    hostPath:
      path: /tmp/storage
```
***
#### Pod'a bağlanan volume container içerisine mount etme
```
      volumeMounts:
        name: data-volume
      - mountPath: /usr/share/nginx/html


```

Podlar silinse de datalar silinmez

Hostpath volume, node Uzerinde olusturulan bir dosya yada dizini pod içerisine hizlica baglamak istedigimizde kullanılmaktadır. 

***
#### POD içerisinde ki volume bilgisini görüntüleme
```
kubectl describe pods volume-test
```

ReadWriteOnce - volume sadece tek bir node üzerine bağlanabilir 

ReadOnlyMany - volume birden fazla node’a sadece okunabilir modda bağlanır

ReadWriteMany - volume birden fazla node’a hem okuma hemde yazma modunda bağlanabilir

ReadWriteOncePod- volume tek bir Poda okuma-yazma şeklinde bağlanabilmektedir


Retain --> Pod silinse dahi datalar kalıcı olmaktadır.

Recycle --> Güncel sürümlerden kaldirilmistir. Volume ile işimiz bittiğinde volume silinmez ama içindeki tüm datalar silinir

Delete --> Pod kaldirildiginda volume ve icindeki tum datalar ile silinir

