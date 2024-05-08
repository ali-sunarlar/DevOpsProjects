Nedir ?
Kubernetes cluster içerisinde bulunan node'ları pasif moda çekmek için kullanılmaktadır. cordon aktif edildiğinde node üzerindeki unschedulable seçeneği true olarak işaretlenir ve node artık yeni bir nesne kabul etmez.



Kullanım:
kubectl cordon NODE 

komutuyla ilgili node unschedulable=true olarak işaretlenir ve node yeni gelen talepleri üzerine almaz.

kubectl uncordon NODE 

komutuyla ilgili node unschedulable=false olarak işaretlenir ve node yeni gelen talepleri kabul eder

--help diyerek detaylara ulaşabiliriz




Örnek:
1- Cordon özelliğini aktif olmadan önce node listemesi


2- Cordon özelliğini aktif olmadan önce node detaylarında unschedulable özelliği false olarak gözükür


3- Minikube node'u üzerinde cordon özelliğinin aktif hale getirilmesi.


4- Node detaylarına baktığımızda Minikube Node'unun SchedulingDisabled olarak işaretlendiğini görürüz


5- Yine Node detaylarında unschedulable özelliği true olarak değiştirilir. Bunu gördüğümüzde Node üzerine POD kabul etmeyeceğini anlayabiliriz


5- Cordon özelliği aktifken yeni bir pod oluşturma


6- Cluster içerisinde uygun bir node olmadığı için POD pending modda beklemede kalır


7- POD detaylarına bakıldığında FailedScheduling olarak uyarı verdiğini görürüz


8- Node'u eski haline almak için uncordon komutunu çalıştırırız


9- POD listelemesi yaptığımzda POD'un oluşturulmaya başladığını görürüz



10- Node durumuna baktığımda SchedulingDisabled durumunun kalktığını göreceğiz


11- Yine Node detaylarında unschedulable özellğinin false olarak işaretlenecektir


-->> Kısaca kubernetes cordon komutu cluster içerisinde ki Node'ları pasif moda çekmek için kullanılmaktadır

Umarım açıklayıcı olmuştur :)

Lütfen demo ortamınızda test ediniz.