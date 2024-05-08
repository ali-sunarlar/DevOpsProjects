## 🧑 Ders: Probe

### 📗Bu bölümde Probe Yönetim işlemlerini bulacaksınız📗

#### Probe Nedir
***
```
Probe’lar Pod’ların sağlık durumunu kontrol etmek için kullanılmaktadır. 
Probe Periyodik olarak cluster’da yapılan diagnostik (tarama) operasyonudur
```
***
#### Probe Türleri
```
Readiness Probe

Livevess Probe

Startup Probe
```

Readiness Probe, Uygulamanızın hazır olup olmadığını Kubernetes'e bildirmek için amacıyla
kullanılmaktadır. Kubernetes, ilgili POD’a trafik göndermeden önce POD’un hazır durumda olup
olmadığını kontrol eder. Eğer POD’un hazır olmadığını görürse, cevap alana kadar trafik göndermeyi
durdurur

Liveness Probe, Uygulamanın sağlıklı çalışıp çalışmadığını kontrol etmek amacıyla kullanılmaktadır.
Uygulama sorunsuz bir şekilde çalışıyorsa, Kubernetes onu kendi haline bırakır. Uygulama cevap
vermiyorsa, Kubernetes Pod'u kaldırır ve yerine yenisini oluşturur

Startup Probe, İlk çalıştırılan Probe’dur. Yavaş ayağa kalkan uygulamalar için kullanılmaktadır. Probe
ayağa kalkmadan Pod’un kubernetes tarafından ortadan kaldırılması önlenmiş olur. Liveness Probe
ile birliktekullanılabilir.


***
#### Probe Yöntemleri
```
ExecAction
TCPSocketAction
HTTPGetAction
```

Exec, Pod içerisinde komut çalıştırmak için kullanılmaktadır. Böylece gerekli test işlemi yapılır. Komut
çalıştırıldıktan sonra dönen değer 0 ise uygulama sağlıklı bir şekilde çalışıyor demektir, farklı bir değer
dönerse uygulamanın crash olduğu düşünülerek gerekli restart işlemi yapılır.

TCPSocket, YAML dosyasında belirtilen TCP port bilgisinin pod içerisinde ulaşılabilir olup olmadığını
kontrol etmek için kullanılmaktadır

HTTPGet, YAML dosyasında belirtilen http adresine ve portuna sorunsuz bir şekilde erişilip erişilmediğini
kontrol etmek amacıyla kullanılmaktadır. 200 ile 400 arasında dönen değer başarılı olarak kabul edilir.
Belirtilen değerlerin dışında bir değer dönerse podun sorunlu olduğu düşünülür ve gerekli restart işlemi
yapılır



***
#### Probe Sonuç
```
Success: Konteyner test işlemini başarılı bir şekilde geçmiştir
Failure: Konteyner test işleminde hatayla karşılaşılmıştır.
Unknown: Test başarısız olmuştur ama herhangi bir işlem yapılmaz
```
***
#### Probe Yapılandırma
```
initialDelaySeconds: Konteyner başlayıp Probe başlamadan önceki geçen süre  (default: 0)
periodSeconds: Yoklama sıklığı için geçen süre (default: 10)
timeoutSeconds: Zaman aşımının sona ereceği süre (default: 1)
successThreshold: Konteynerin doğru çalışmasını belirleyeceği minimum başarılı deneme sayısı (default: 1)
failureThreshold: Yeniden başlatılacağı başarısız deneme sayısı (default: 3)
```

