--sort-by Komut Detayları - Dikkat
Nedir:

--sort-by ifadesi, kubect get komutu parametrelerindendir. kubectl get --help komutunda detaylara ulaşabilirsiniz.  --sort-by paremetresi önünde yazılan kritere göre çıktı sıralaması yapmak için kullanılır. 

Kullanım:

--sort-by önünde yazılacak komut JSONPath formatında olmalıdır.

Sistem üzerinde oluşturulan POD'ları oluşturulma zamanına göre listelemek istiyoruz ?

Aşadaki deneme adındaki pod nesnesi JSON formatında gösterilmiştir.  Aşağıdaki kırmızı çizgi ile gösterdiğim path bilgisini takip ederek komutumu yazacağız.




Komutumuz aşağıdaki şekilde olacaktır.

kubectl get po --sort-by=.metadata.creationTimestamp

Böylece POD lar oluşturulma tarihine göre listelenecektir. Aşağıda komut çıktısında POD'lar oluşturulma zamanına göre listelenmiştir. AGE kısmında POD'ların süreleri gösterilmektedir.


Peki bu çıktıyı dışarıya aktarmak istersek ne yapacağız ?

Bunun için komut sonuna >> ifadesini kullanabiliriz. Örneğin list.txt şeklinde çıktıyı kayıt edebiliriz.

kubectl get po --sort-by=.metadata.creationTimestamp >> list.txt




Sistem üzerinde bulunan POD'ları IP adreslerine göre sıralamak istiyoruz !

Bunun için yine JSON çıktısına kontrol edebiliriz. Aşağıda JSON çıktısı gösterilmiştir.

.podIP  ifadesi .status  ifadesinin alt başlığı konumundadır.


Komutumuz aşağıdaki şekilde olacaktır.

kubectl get po --sort-by=.status.podIP

Böylece podlar IP adreslerine göre küçükten büyüğe  sıralanacaktır.


Çıktıyı iplist.txt dosyasına kayıt etmek istersek >> parametresini kullanarak aktaracağız.

kubectl get po -o wide --sort-by=.status.podIP  >> iplist.txt



Yukarıdaki JSON dosyasına bakarak PODların başlama zamanına göre start.txt dosyasına kayıt etmek istersek aşağıdaki komutu kullanacağız.

kubectl get po --sort-by=.status.startTime >> start.txt



** Burada önemli olan nokta JSON path bilgisinin düzgün yazılmasıdır. Bilginize