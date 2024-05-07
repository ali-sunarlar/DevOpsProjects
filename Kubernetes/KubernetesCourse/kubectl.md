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





