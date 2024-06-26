## 🧑 Ders: Init-Container

### 📗Bu bölümde Init-Container Pod Yönetim işlemlerini bulacaksınız📗(murataksu.net)

#### Init-Container, Pod içerisinde ana container ayağa kalkmadan önce init-containerın öncelikli olarak çalıştırılması
***
```
Name:          myapp-pod
Namespace:     default
[...]
Labels:        app=myapp
Status:        Pending
[...]
Init Containers:
  init-myservice:
[...]
    State:         Running
[...]
  init-mydb:
[...]
    State:         Waiting
      Reason:      PodInitializing
    Ready:         False
[...]
Containers:
  myapp-container:
[...]
    State:         Waiting
      Reason:      PodInitializing
    Ready:         False
[...]
```
***
#### Init Container durumlarını kontrol etme
```
kubectl get pod nginx --template '{{.status.initContainerStatuses}}'
```
***
#### Pod içerisindeki init containerın root dizini listeleme
```
kubectl exec pod/nginx --container c1 -- ls -l
```
***
#### Pod içerisindeki container loglarını listeleme
```
kubectl logs <pod-ismi> --container <init-container-ismi>
Ör:kubectl logs --container=init-mydb initpod
```
***
#### Label değeri app=sleep olan Pod içerisindeki init contailer'ların durumlarını json formayında görüntüleme
```
kubectl get pod -l app=sleep -o jsonpath='{.items[0].status.initContainerStatuses[*].name}'
```
***
#### InitContainer Status Anlamları
```
Status	Meaning
Init:N/M	The Pod has M Init Containers, and N have completed so far.
Init:Error	Init-Container çalıştırılamadı.
Init:CrashLoopBackOff	Bir Başlangıç Konteyneri tekrar tekrar başarısız oldu.
Pending	Henüz init containerı çalışmaya başlamadı.
PodInitializing or Running	Pod, ini-containerı çalıştımayı tamamladı
```


 initpod pod içerisinde ki init-mydb containerın loglarını görüntüleyin

 kubectl logs --container=init-mydb initpod

  initpod pod üzerine app=initapp label ataması yapın

  kubectl label pod initpod "app=initapp"

init-myservice konteynerın aradığı myservice için service eklemesi yapın.

kubectl expose pod initpod --name=myservice --port=80 --target-port=9376

initpod pod içerisinde ki init-myservice containerın loglarını görüntüleyin

("** server can't find" yerine servis bilgilerinin geldiğini gözlemleyin.  Not: Gelmesi zaman alabilir)

       ■ Name: myservice.default.svc.cluster.local

       ■ Address: 10.102.133.150

kubectl logs --container=init-myservice initpod

