Kubernetes Drain
Nedir ?
Kubernetes cluster içerisinde bulunan node'ları maintinance yani bakım moduna almak için kullanılmaktadır. Örneğin kernel upgrade, hardware maintenance yada sunucu reboot gibi işlemlerden önce node üzerinde drain işlemi yapılarak cluster servisinden çıkarılır

Node üzeride Replicaset veya Deployment vb nesneler varsa bunlara ait POD'lar farklı node üzerine taşınacaktır. Tekil olarak çalışan POD'lara dokunulmaz. 

drain aktif edildiğinde node üzerindeki unschedulable seçeneği true olarak işaretlenir ve node artık yeni bir nesne kabul etmez. Node'u eski haline almak için uncordon işlemi uygulanır, böylece unschedulable özelliği tekrar pasif yani false olarak işaretlenir.



Kullanım:
kubectl drain NODE

komutuyla ilgili node drain moduna alınmış olur fakat üzerinde çalışan POD lara dokunulmaz. Yeni gelen POD lar kabul edilmez. unschedulable özelliği true olarak işaretlenir.

kubectl drain NODE --force

komutuyla ilgili node drain moduna alınması için zorlanır. ReplicationController, Job ve DaemonSet nesneleri üzerinde de işlem yapılır.

kubectl drain NODE --force --ignore-daemonsets

komutuyla ilgili node drain moduna alınması için zorlanır ve uyarılar yok sayılır. DaemonSet tarafından yönetilen POD'lar yok sayılır.

kubectl drain foo --grace-period=900

komutuyla drain işlemi belirli bir süre içinde tamamlanmaya çalışılır



--help diyerek detaylara ulaşabiliriz




Örnek:
1- Drain özelliğini çalıştırılamdan önce node durumu


2- Drain özelliğini aktif olmadan önce node detaylarında unschedulable özelliği false olarak gözükür


3- Demo adında bir deployment nesnesi oluşturduk. Deployment nesnesi 3 adet POD 'u minikube-m02 node'u üzerinde oluşturdu


4- minikube-m02 Node'u üzerinde drain komutu çalıştırıldıktan sonra POD'lar farklı bir node üzerinde kaydırılır ve NODE cordoned olarak işaretlenir yani yeni gelen POD'ları kabul etmez


5- minikube-m02 üzerinde çalışan POD'lar minikube üzerine taşınmış durumda


6- Nodeları listelediğimizde minikube-m02  Node'u Status olarak SchedulingDisabled şeklinde işaretlendiği görülür. Buda yeni POD kabul etmeyeceği anlamına gelir.


7- minikube-m02  Node'un detaylarına baktığımızda unschedulable özelliğini true şeklinde değiştirildiğini görürüz


8- Node üzerinde işlemimiz tamamladıktan sonra tekrar cluster servisine dahil etmek istersek uncordon komutunu çalıştıracağız


9- Node üzerinde uncordon işlemini yaptıktan sonra Node yeni POD kabul edebilir duruma gelmiştir.


Umarım açıklayıcı olmuştur :)