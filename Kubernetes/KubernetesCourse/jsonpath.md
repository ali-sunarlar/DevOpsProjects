--output=jsonpath Komut Detayları- Önemli
Nedir:

  --output=jsonpath parametresi,   kubectl get pods --output=json çıktısında listelenen değerlere, komut satırı üzerinden tek bir komut ile erişmek için kullanılır. Komut ayraçlar {} içinde yazılır ve JSONPath olarak  tanımlanır. 

https://kubernetes.io/docs/reference/kubectl/jsonpath/

İlgili link üzerinden JSONPath  detaylarına ulaşabilirsiniz.

Kullanım:

Sistemimizde nginx imageını kullanan deneme adında bir POD oluşturduk .

kubectl get pods deneme --output=json  komutu ile baktığımızda deneme POD detayları JSON formatında gösterilecektir. Çıktı aşağıdaki şekilde olacaktır. Bu çıktıdaki verilere komut satırı üzerinden erişmek için -o=jsonpath=  ifadesini kullanacağız. Örneğin kullandığı image bilgisi , oluşturulma zamanı, IP adresi gibi.


(Not: Resimleri sağ tıklayıp fark sekmede göster diyerek büyütebilirsiniz)

kubectl get pods deneme -o=jsonpath= ifadesinden sonra '{}' içerisine komutu yazacağız.

Örneğin: Yukarıda ilk kırmızı çizgi ile gösterilen name bilgisini okumak istersek metadata.name yolunu izleyeceğiz. Çünkü name değişkeni metadata 'nın bir alt başlığıdır.

Yazacağımız komut:  kubectl get pod deneme -o=jsonpath='{.metadata.name}'  şeklinde olacaktır.

Metadata altında ki namespace bilgisine erişmek istersek;
kubectl get po deneme -o=jsonpath='{.metadata.namespace}'

Metadata altında ki creationTimestamp bilgisine erişmek istersek;
kubectl get po deneme -o=jsonpath='{.metadata.creationTimestamp }'

udi bilgisine erişmek için;
kubectl get po deneme -o=jsonpath='{.metadata.uid }' 

komutunu kullanacağız. Dikkat edilirse komut yazım şekli path yoluna göre yapılmaktadır.



PEKi ikinci kırmızı çizgi ile gösterilen yolu yani container image bilgisini öğrenmek istersek ne yapacağız?

Bunun için yazacağımız komut:

kubectl get po deneme -o=jsonpath='{.spec.containers[*].image}'   şeklindedir. Şimdi bu komutu inceliyelim.

Burada dikkat ederseniz containers ifadesinin önünde [] ve içerisinde * işareti bulunmaktadır. Containers ifadesinden de anlaşılacağı gibi POD içerisinde birden fazla container aynı anda çalıştırılabilir. Bu container'ları birbirinden ayırt etmek için [] işareti kullanılır. * ifadesi POD içerisinde çalışan tüm containerı kapsa anlamına gelir. [0] şeklinde yazarsak ilk container ı [1] şeklinde yazarsak ikinci container bilgisini getir anlamına gelmektedir

Container ismini almak istersek

kubectl get po deneme -o=jsonpath='{.spec.containers[*].name}'  komutunu kullanacağız. * işaretiyle POD içerisindeki tüm container ın isimleri öğrenilmek istenmiştir.

Peki üst resimdeki mountPath bilgisini almak istersek ne yapacağız;

Dikkat ederseniz mountPath bilgisi volumeMounts ifadesinin altındadır. volumeMounts bilgiside .spec.containers. yolu üzerindedir. volumeMounts ifadesinin yine çoğul olduğunu görüyoruz. O sebeple bu ifade önünde [*] tanımını yapacağız. * ifadesi yine tüm volumeMounts'lar anlamına gelmektedir.

Yazacağımız komut:

kubectl get po deneme -o=jsonpath='{.spec.containers[*].volumeMounts[*].mountPath}'

şeklinde olacaktır.

İsim bilgisini almak istersek;

kubectl get po deneme -o=jsonpath='{.spec.containers[*].volumeMounts[*].name}'

şeklinde yazacağız.

Komut yazımında büyük küçük harf duyarlılığı vardır.

Farklı bir örneğe bakacak olursak , Örneğin alt resim de gözüken POD'un IP bilgisini öğrenmek istediğimizi düşünelim. podIP bilgisinin status başlığı altında olduğunu görüyoruz.

Yazacağımız komut:

kubectl get po deneme -o=jsonpath='{.status.podIP}'

şeklinde olacaktır.

Farklı bir örneğe bakacak olursak; aşağıdaki resimde sistemde ki tüm nesneler JSON formatında listelenmiştir.

Sistemdeki tüm podlar üzerinde sorgulama yapmak istediğimizde bu sefer pod ismini yazmadan,

kubectl get pods -o=jsonpath=   şeklinde komutumuzu yazacağız

Akabinde .items[*] başlığıyla tüm nesneler üzerinde sorgulama yapmak istediğimizi söylüyoruz.

Sonrasında Örneğin ['metadata.name'] diyerek tüm isimleri almak istediğimizi söylüyoruz.

Komutumuz;

kubectl get pods -o=jsonpath="{.items[*]['metadata.name']}"

şeklinde olacaktır.

Komut çıktısı : 127.0.0.1 ve 127.0.0.2 şeklindedir.

.items[*] komutunda ki * yerine .items[0] şeklinde yada .items[1] yazarak hangi objeyle ilgili bilgiye erişmek istiyorsak onu yazabiliriz.


Resim üzerinde ikinci örnekte aynı anda iki tanım sorgulaması yapılmak istenmiştir. Aranacak ifadeler isim ve kapasite bilgisidir. Çıktıya dikkat edilirse capacity ve name bilgisi items[*].status ifadesinin alt başlığı konumundadır ve yazım işlemi bu path bilgisine göre yapılacaktır.

||| kubectl get pods -o=jsonpath="{.items[*]['metadata.name', 'status.capacity']}"

Aynı satırda  iki farklı sorgulama işleminde araya virgül konularak sorgulama yapılmıştır.

Aşağıdaki tabloda ifadeler, açıklamaları ve kullanım detayları görülmektedir.

Aşağıdaki örnekleri lütfen inceleyin.

** Kısaca hangi nesneye erişilmek istenirse path bilgisi alınır ve  yukarıdan aşağıya doğru jsonpath takip edilerek komut yazılır.

** Tüm nesneler üzerinde sorgulama yapılacaksa pod ismi yazmadan .items[*] ifadesiyle sorgulama yapılır.

** Pod ismi yazılırsa doğrudan sorgulama yapılabilir

Aşağıdaki web adresi üzerinden detaylara erişebilirsiniz.

https://kubernetes.io/docs/reference/kubectl/jsonpath/



Sorgulama: (Dikkat)

Eğer bir çıktı da kelime sorgulaması yapmak istersek;

Windows işletim sisteminde  | findstr "XXXXXX"

Linux işletim sisteminde | grep "XXXXX"

komutunu kullanmaktayız.

Örnek: JSON çıktısında podIP olan satırları getirir.

Windows:   kubectl get pods --output=json | findstr "podIP"

Linux:   kubectl get pods --output=json |  grep "podIP"

Burada sadece grep içerisinde belirtilen kelime satırları gösterilecektir