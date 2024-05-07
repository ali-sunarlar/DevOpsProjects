"kubectl explain" Komut Detayları - Hayat kurtarır
Özellikle CKA sertifika sınavında, takıldığımız yerde bu komut ile işinizi kolaylaştırabilirsiniz.

Nedir?
Nesne detayları hakkında bilgi sahibi olmak ve incelediğimiz nesnenin alt parametlerini listelemek istendiğinde kullanılmaktadır. Aynı zamanda bu komut ile incelediğimiz nesnenin kubernetes dökümantasyon sayfasındaki linkine de ulaşabiliyoruz.

>> Bildiğiniz gibi CKA sertifika sınavında Kubernetes dökümantosyon sayfasına erişime izin verilmektedir. Nesne detaylarını dökümantasyon sayfası üzerinde de inceleyebiliriz.

Nasıl Kullanılır
kubectl explain komutundan sonra detaylarına bakmak istediğimiz nesne ismini yazıyoruz

kubectl explain pod -->  Örneğin pod nesnesi detaylarına bakalım.


Görüldüğü gibi pod nesnesi detayları ve altında yer alan opsiyonlar listelendi. Bu opsiyonlar ile ilgili detaylar link üzerinde yer almaktadır.

Örneğin pod nesnesi altında  metadata içerisinde yer alan parametreleri listemek istersek

kubectl explain pod.metadata

komutunu kullanacağız. Böylece o nesne altındaki parametler açıklamasıyla listelenecektir.


Peki ben sadece nesne altında ki parametreleri soya ağacı şeklinde listelemek istersem ne yapacağım ? :)

Bunun için komut sonuna --recursive parametresini ekleyeceğiz.

kubectl explain pod.metadata --recursive


Böylece sadece nesne altındaki parametreler listelemiş olacak. Örneğimizde pod.metadata altındaki parametreler listelenmiştir.