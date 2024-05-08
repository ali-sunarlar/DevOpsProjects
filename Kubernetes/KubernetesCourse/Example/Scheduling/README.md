## 🧑 Ders: Scheduling

### 📗Bu bölümde Scheduling işlemleri hakkında bilgi bulacaksınız📗

#### Nedir ?
***
```
Scheduling, Kubernetes üzerinde oluşturulacak podların talep edilen nodelar üzerinde oluşturulmasını yada oluşturulmamasını sağlayan özelliktir

3 Farklı Node seçim yöntemi bulunur. Bunlar:

Nodeselector
Affinity
Taint & Toleration

*nodeSelector, node seçim yöntemlerinden en basit olanıdır. Her konu kendi başlığı altında incelenecektir. 
Bu bölümde nodeselector detayları verilmiştir. 
```
***
#### Node üzerine label ataması yapma
***
```
kubectl label node minikube-m03 disktype=ssd
```
***
#### Nodelar üzerinde bulunan labelları listeleme
```
kubectl get node minikube-m03 --show-labels
```
***
#### YAML dosyasında , podun talep edilen node üzerinde oluşturulması için, label bilgisinin yazılması
```
  nodeSelector:
    disktype: ssd
```
***
#### POD'un talep edilen node üzerinde oluşturulduğunun kontrolü
```
kubectl get pods -o wide

kubectl get pods --show-labels -o wide
NAME               READY   STATUS    RESTARTS   AGE   IP          NODE             NOMINATED NODE   READINESS GATES   LABELS
nodeslctor-mysql   1/1     Running   0          75s   10.1.0.96   docker-desktop   <none>           <none>            <none>
nselectorpod       1/1     Running   0          13s   10.1.0.97   docker-desktop   <none>           <none>            <none>
```
