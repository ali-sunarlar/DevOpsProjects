--output=custom-columns= Komut Detayları
Nedir:

kubectl get --output parametrelerinden biri olan custom-columns opsiyonu, listeme işleminde özel sütunlar tanımlamamıza ve yalnızca istediğimiz ayrıntıları içeren tablo oluşturmamıza  izin vermektedir.

Ve akabinde bu tabloyu çıktı alıp kullanabiliriz.



Kullanım:

$ kubectl get pods -o=custom-columns=

ifadesinden sonra JSON dosyasında path bilgisine göre hangi alanları eklemek istiyorsak onları sıralayacağız. İlk önce sutün ismini sonrasında iki nokta koyup JSON içerisinde ki path bilgisini yazacağız. Başlıkları virgül ile birbirinden ayırıyoruz.

Örnek:

kubectl get pods -o=custom-columns=NAME:.metadata.name,NSPACE:.metadata.namespace

Örneği incelediğimizde tablonun birinci sütunü .metadata.name bilgilerini içerecek ve başlığı NAME şeklinde olacak. İkinci sutünda .metadata.namespace bilgileri olacak ve başlığı NSPACE şeklinde olacaktır.

Aşağıda örnek çıktısı gözükmektedir. Sütun başlığı verdiğimiz tanım olmuştur.


Yine dilenirsek farklı değerler eklenerek tabloyu uzatabiliriz.

kubectl get pods -o=custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,RSRC:.metadata.resourceVersion,CONTAINER-IMAGES:.spec.containers[*].image



Komut sonuna >> ifadesi eklenerek dosyaya çıktıyı kayıt edebiliriz.

kubectl get pods -o=custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,RSRC:.metadata.resourceVersion,CONTAINER-IMAGES:.spec.containers[*].image >> podinfo.txt


--no-headers parametresini kullanarak tüm başlıklar  temizleyebiilr ve sadece çıktı listelemesi yapabiliriz.