kubectl run komut yazım şekli

kubectl run NAME --image=image [--env="key=value"] [--port=port] [--dryrun=server|client] [--overrides=inline-json] [--command] -- [COMMAND] [args...]

my-web adında nginx image’ını kullanan pod oluşturma/çalıştırma

kubectl run my-web --image=nginx

hazelcast adında hazelcast image’ını kullanan, 5701 portu açılarak pod oluşturma/çalıştırma

kubectl run hazelcast --image=hazelcast --port=5701

my-web adında nginx image’ını kullanan pod oluşturmadan önizleme

kubectl run my-web --image=nginx --dry-run=client

my-web adında nginx image’ını kullanan pod yaml dosyasını ekrana çıktı alma

kubectl run my-web --image=nginx --dry-run=client -o yaml

my-web adında nginx image’ını kullanan pod yaml dosyasını mypod.yaml olarak çıktı alma

kubectl run my-web --image=nginx --dry-run=client -o yaml >> mypod.yaml

my-web adında nginx image’ını kullanan pod kapandığında yeniden başlatmama

kubectl run my-web --image=nginx --restart=Never

my-web isimli podun loglarını görüntüleme

kubectl logs my-web

my-web isimli podun log sıralamasını değiştirerek görüntüle

kubectl logs my-web --previous

my-web isimli podun loglarını akış olarak görüntüle

kubectl logs --follow my-web

my-web isimli podun loglarını en son 20 satırlık kısmını görüntüle

kubectl logs --tail=20 my-web

my-web isimli podun loglarını son 1 saatlik kısmını götüntüle

kubectl logs --since=1h my-web

my-web isimli poddaki tüm container loglarını görüntüle

kubectl logs my-web --all-containers=true

my-web isimli podu silme

kubectl delete pods my-web

Baz ve foo isimli podları ve servisleri silme

kubectl delete pod,service baz foo

Pod.yaml dosyasında ki nesneleri silme

kubectl delete -f pod.yaml

Default namespacedeki tüm podları silme

kubectl delete pods --all

Default namespacedeki oluşturulmuş tüm nesneleri silme

kubectl delete all --all

my-ns namespacedeki tüm podları ve servisleri silme

kubectl delete -n my-ns pod,svc --all

foo isimli podu en kısa sürede silme

kubectl delete pod foo –now

foo isimli podu silmeye zorla

kubectl delete pod foo --force

İsmi debug olan, busybox imajını kullanan ve pod içerisinde sürekli uyuma eylemi yaptıran komuttur

kubectl run debug --image=busybox -- sleep infinity

İsmi tomcat olan, tomcat'ın son sürüm imajını kullanan ve restart durumunda pod'u tekrar ayağa kaldırmayan komuttur

kubectl run tomcat --image=tomcat --restart=Never

Kubernetes sertifika sınavına giren Elif,  oluşturduğu mynginx POD'unun silmek istediğinde aldığı hatayı beklemek istememesi üzerine aşağıdaki komutlardan hangisini kullanmalıdır 

kubectl delete pods mynginx --grace-period=0 --force ( Sertifika sınavında bu özellikle kullanılması gereken komutlar arasında yer almaktadır)

Kubernetes üzerinde var olan nesnelerin hangi parametre ile kullanıldığı, detayları, komut kullanım şeklini öğrenmek isteyen biri aşağıdakilerden hangi komutu kullanmalıdır?

kubectl explain komutu nesnelerin kullanımı, parametlerileri, detaylarıyla ilgili açıklama yapar

deployment nesnesi içerisinde ki iscsi parametleri listelenmen istenmiştir. 

kubectl explain deployment.spec.template.spec.volumes.iscsi

pod.json dosyasini siler

kubectl delete -f ./pod.json

ismi busybox olan busybox imajını kullanan, POD oluşturduktan sonra shell içerisine bağlanan, işlem tamamlanıp POD'dan çıkınca da POD'u silen komuttur

kubectl run -i --tty --rm busybox --image=busybox -- sh

..... lokaldeki 5000 portu dinler ve my-app pod'unun 6000 numaralı portuna yönlendirir

kubectl port-forward my-app 5000:6000

Kubernetes konusunda hiç bilgisi olmayan biri, pod nesnesi içerisindeki spec (pod.spec) başlığından sonra hangi paremetrelerin kullabileceğini nasıl öğrenir ?

kubectl explain pod.spec (explain komutu nesne detaylarını ve komut kullanımı göstermek için kullanılmaktadır)

```
Pod ismi: mysweetpod
image: busybox
Yeniden Başlatma: Never
Konteyner içerisinde çalıştırılacak komut: echo "GULUMSEE"
```
Yukarıdaki özelliklerde YAML dosyasını oluşturarak mysweetpod.yaml dosyasına kayıt eden komuttur ?

kubectl run mysweetpod --image=busybox --restart=Never --dry-run=client -o yaml --command -- echo "GULUMSEE" > mysweetpod.yaml

..... kubernetes sistemi üzerinde sadece tanımlı aktif config bilgisini görüntüler

kubectl config view --minify

....Servisleri isimlerine göre sıralayıp listeler

kubectl get services --sort-by=.metadata.name

"kubectl run" komutu parametrelerinden olan  "--dry-run" opsiyonu ne amaçla kullanılır

komutu test etmek amacıyla


```yml
apiVersion: v1
kind: Pod
metadata:
  name: tomtom
spec:
  containers:
  - image: tomcat:8.0
    name: tomtom
    ports:
    - containerPort: 80
  restartPolicy: Always
```
YAML dosyasında ki containerPort bilgisi aşağıdaki komut satırından hangisiyle sorgulanır

```sh
kubectl get pod tomtom -o jsonpath='{.spec.containers[*].ports[*].containerPort}'
```

..... tanımlı namespace üzerinde durumu running olmayan podları listeler

```sh
kubectl get pods --field-selector status.phase!=Running
```

..... app=special label etiketine sahip podların isimlerini listeler

```sh
kubectl get pods -l app=special --output=jsonpath='{.items[*].metadata.name}'
```

..... default namespace'inde bulunmayan pod isimlerini name değişkenine aktarıp, ekrana yazdıran

```sh
## 
$name=kubectl get pods --all-namespaces --field-selector metadata.namespace=default --output=jsonpath='{.items[*].metadata.name}' 
## 
echo $name 
## İlk satırda pod isimlerini name değişkenine aktarıp ikinci satırda yazdırıyoruz.
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: tomtom
spec:
  containers:
  - image: tomcat:8.0
    name: tomtom
    ports:
    - containerPort: 80
  restartPolicy: Always
```
..... Yukarıdaki YAML dosyasındaki image bilgisini sorgulayıp ekrana yazdıran komuttur

```sh
## 
$name=kubectl get pods --field-selector metadata.name=tomtom --output=jsonpath='{.items[*].spec.containers[*].image}' 
## 
echo $name
```


apiVersion: v1
kind: Pod
metadata:
  name: tomtom
spec:
  containers:
  - image: tomcat:8.0
    name: tomtom
    ports:
    - containerPort: 80
  restartPolicy: Always
Yukarıdaki restartPolicy bilgisi aşağıdaki hangi komut ile öğrenilmektedir

kubectl get pods tomtom --output=jsonpath='{.spec.restartPolicy}'



... pod bilgisini $name değişkenine aktarıp loglarını görüntüleyen komuttur


$name=kubectl get pods --field-selector metadata.name=tomtom --output=jsonpath='{.items[*].metadata.name}' 

kubectl logs $name

.... restart policy ayarı always olan ve çalışan podları list.txt dosyasına kaydeden komuttur

kubectl get pods --field-selector=status.phase=Running,spec.restartPolicy=Always > list.txt


.... custom-columns kullanılarak pod isimlerini ve pod durumlarını listeleyen komuttur

kubectl get po -o=custom-columns="POD_NAME:.metadata.name, POD_STATUS:.status.containerStatuses[].state"

POD_NAME    POD_STATUS
tomtom     map[running:map[startedAt:2024-05-08T15:37:26Z]]


apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - while true; do echo hello; echo hello again;done
    image: busybox
    name: mypod
  restartPolicy: Never
Yukarıdaki YAML dosyası komut yazım şekli aşağıdakilerden hangisidir

kubectl run busybox --image=busybox --restart=Never --dry-run=client -o yaml -- /bin/sh -c "while true; do echo hello; echo hello again;done" > yamlfile.yaml


apiVersion: v1
kind: Pod
metadata:
  name: log-writer-reader1
spec:
  containers:
    - name: log-writer
      image: busybox
      command: ['sh', '-c', 'sleep 3600']
    - name: log-reader
      image: busybox
      command: ['sh', '-c', 'echo The app is running! && sleep 3600']
log-writer-reader1 pod içerisindeki log-reader command değerini sorgulayan komut aşağıdakilerden hangisidir

kubectl get pod log-writer-reader -o jsonpath='{.spec.containers[1].command}'

apiVersion: v1
kind: Pod
metadata:
  name: log-writer-reader2
spec:
  containers:
    - name: log-writer
      image: busybox
      command: ['sh', '-c', 'sleep 3600']
    - name: log-reader
      image: busybox
      command: ['sh', '-c', 'sleep 3600']
log-writer-reader2 pod içerisindeki log-writer containerID değerini sorgulayan komut aşağıdakilerden hangisidir

kubectl get pod log-writer-reader -o jsonpath='{.status.containerStatuses[0].containerID}'