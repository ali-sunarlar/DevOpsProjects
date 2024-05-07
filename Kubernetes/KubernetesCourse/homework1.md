Ubuntu Image'ını kullanan ve adı ubuntu olan bir Pod oluşturun.

Bu podun sürekli ayakta kalması için container içerisinde sürekli uyuma komutunu çalıştırın.

Pod'u oluştururken label ve environment bilgisi ekleyin. Label bilgisi olarak (team=system) bilgisini environment olarak   (HEY_SERVICE_HOST=10.10.10.10) bilgisini ekleyin.

Pod yeniden başlatma ayarını hiçbir zaman şeklinde ayarlayın.

Container içerisinde update işlemini yaptıktan sonra(apt update), nginx (apt install nginx) ve curl (apt install curl) paketlerini yükleyin

Nginx servislerini yeniden başlatın. (service nginx restart)

Nginx ana sayfasının geldiğini komut satırı üzerinden kontrol edin (curl localhost)

Bilgisayarınızın lokal diskinde index.html dosyası oluşturun ve içerisine "Web Sayfama Hosgeldiniz" şeklinde not düşüp kaydedin.

Bu dosyayı nginx'in yayın yaptığını path üzerine kopyalayın (/var/www/html/)

Web sayfanıza erişin ve yazdığınız notun geldiğini görün

POD oluştururken verdiğiniz environment bilgisinin POD içerisine eklenip eklenmediğini POD içerisine bağlanmadan kontrol edin.

Json formatını kullanarak, POD hangi host üzerinde oluşturulduysa onun IP bilgisini sorgulayarak podhostip.txt dosyasına kayıt edin.

Ubuntu Pod'u üzerinde eklenen "team=system" label bilgisini "team=developer" şeklinde değiştirin ve "app=webserver" label eklemesi yapın.

Ubuntu POD'unu label bilgisini kullanarak silin.

Aşağıdaki YAML Dosyasını kubectl aracını kullanarak yazdırın.

Pod İsmi: debug

Image: busybox

Etiket: app=debug

Environment: MYAPP_SERVICE_PORT=443

Yeniden Başlatma: Asla

Konteyner İçerinde Çalıştırılacak Komut: Sonsuz Uyuma

Yaml ismi: debug.yaml



Ubuntu Image'ını kullanan ve adı ubuntu olan bir Pod oluşturun.

Bu podun sürekli ayakta kalması için container içerisinde sürekli uyuma komutunu çalıştırın.

Pod'u oluştururken label ve environment bilgisi ekleyin. Label bilgisi olarak (team=system) bilgisini environment olarak   (HEY_SERVICE_HOST=10.10.10.10) bilgisini ekleyin.

Pod yeniden başlatma ayarını hiçbir zaman şeklinde ayarlayın.

kubectl run ubuntu-pod --image=ubuntu --restart=Never --command -- sleep infinity --labels=team=system --env=HEY_SERVICE_HOST=10.10.10.10



Container içerisinde update işlemini yaptıktan sonra(apt update), nginx (apt install nginx) ve curl (apt install curl) paketlerini yükleyin

Nginx servislerini yeniden başlatın. (service nginx restart)

Nginx ana sayfasının geldiğini komut satırı üzerinden kontrol edin (curl localhost)

apt update

apt install -y nginx curl

service nginx restart

curl localhost



Bilgisayarınızın lokal diskinde index.html dosyası oluşturun ve içerisine "Web Sayfama Hosgeldiniz" şeklinde not düşüp kaydedin.

Bu dosyayı nginx'in yayın yaptığını path üzerine kopyalayın (/var/www/html/)

vim index.html

kubectl cp ./index.html ubuntu:/var/www/html/

Web sayfanıza erişin ve yazdığınız notun geldiğini görün

kubectl port-forward ubuntu 9080:80

POD oluştururken verdiğiniz environment bilgisinin POD içerisine eklenip eklenmediğini POD içerisine bağlanmadan kontrol edin.

kubectl exec -it ubuntu -- env



Json formatını kullanarak, POD hangi host üzerinde oluşturulduysa onun IP bilgisini sorgulayarak podhostip.txt dosyasına kayıt edin.

kubectl get pod ubuntu --output=jsonpath='{.status.hostIP}'

Ubuntu Pod'u üzerinde eklenen "team=system" label bilgisini "team=developer" şeklinde değiştirin ve "app=webserver" label eklemesi yapın.

k label pod ubuntu team=developer --overwrite

k label pod ubuntu app=webserver

Ubuntu POD'unu label bilgisini kullanarak silin.

kubectl delete pod -l="app=webserver"

Aşağıdaki YAML Dosyasını kubectl aracını kullanarak yazdırın.

Pod İsmi: debug

Image: busybox

Etiket: app=debug

Environment: MYAPP_SERVICE_PORT=443

Yeniden Başlatma: Asla

Konteyner İçerinde Çalıştırılacak Komut: Sonsuz Uyuma

Yaml ismi: debug.yaml

kubectl run debug --image=busybox --restart=Never --command -- sleep infinity --labels=app=debug --env=MYAPP_SERVICE_PORT=443 -o yaml --dry-run=client > debug.yaml

