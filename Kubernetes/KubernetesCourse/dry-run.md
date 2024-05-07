--dry-run Komut Detayları - Çok Önemli

kubectl run komutu içerisinde gelen en kullanışlı parametlerinden biri --dry-run opsiyonudur.  CKA sertifika sınavında işimizi kolaylaştıracak belki de en önemli parametlerden biridir.

--dry-run opsiyonu kubectl run komutunda yazdığınız ifadeyi canlı sistem üzerinde çalıştırmadan önce test etmemize imkan sağlamaktadır. -o yaml parametresiyle kullanıldığında bizim için önemli olan gücü ortaya çıkar. -o yaml parametresiyle kullanıldığında YAML dosyasını elle yazmamıza gerek kalmadan sistem tarafından  yazdırılmasını sağlar. 

Üç opsiyonla birlikte gelmektedir. Bunlar --dry-run= client , --dry-run= server, --dry-run=none

--dry-run=client -o yaml  komutu, çıktıyı YAML formatında almak için kullanılır.  Böylece komut çalıştırmadan önce ne yapacağını görebiliriz.  =client opsiyonuyla komut api server tarafından doğrulanmadan çalıştırılmış olur. Yani komut api server üzerinden çalıştırılmaz sadece client üzerinde simule edilir.

Örnek Kullanım:

kubectl run test --image busybox --dry-run=client -o yaml

Çıktıda ekrana busybox imagını kullanan POD YAML dosyası içeriği yazdırılacaktır.

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: test
  name: test
spec:
  containers:
  - image: busybox
    name: test
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

Çıktıyı dışarıya almak istersek  >> işaretiyle dilediğimiz path üzerinde YAML dosyası formatında aktarabiliriz. Böylece CKA sertifika sınavında YAML dosyasını oturup baştan yazmak yerine sistem tarafından otomatik olarak yazdırılmasını sağlayabiliriz.

kubectl run test --image busybox --dry-run=client -o yaml >> mybusybox.yaml

En çok kullanacağımız komut şekli =client formatıdır. Hızlıca YAML dosyasına ihtiyacımız olduğunda bu komutu kullanabiliriz. Özellikle deployment yada servis nesneleri kullandığımızda bu komut işimize oldukça fazla yaramaktadır



--dry-run=server -o yaml  komutu, çıktıyı YAML formatında almak için kullanılır.  Burada yazılan komut api server tarafından doğrulanmaktadır. Örneğin aynı isimle nesne sistem üzerinde çalışıyorsa çıktıda komut çalıştırılmış gibi uyarı verecektir ama gerçekte komut sistem üzerinden çalıştırılmaz. Sadece simüle edilmektedir.  

Örnek

kubectl run nginx --image=nginx --port=80 --restart=Never --dry-run=server -o yaml

Çıktı

Error from server (AlreadyExists): pods "nginx" already exists



--dry-run=none -o yaml  komutu, çıktıyı YAML formatında almak için kullanılır.  Burada yazılan komut api server tarafından doğrulanır. Komut sunucu üzerinde simüle edilir ve çalıştırılır.

kubectl run nginx --image=nginx --port=80 --restart=Never  --dry-run=none -o yaml