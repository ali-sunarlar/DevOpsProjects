Bir veya daha fazla yerel bağlantı noktasını Pod’a yönlendirme komut sentaksı

$ kubectl port-forward TYPE/NAME [options] LOCAL_PORT:REMOTE_PORT

mypod isimli podun 5000 portunu erişilebilir yapma ve yönlendirme

$ kubectl port-forward mypod 5000 

Lokal bilgisayarın 8080 portunu podun 80 portuna yönlendirme

$ kubectl port-forward mypod 8080:80

Lokal bilgisayarın rastgele bir portunu podun 80 portuna yönlendirme

$ kubectl port-forward mypod :80

Lokal bilgisayarın rastgele bir portunu podun 3306 portuna yönlendirme

$ kubectl port-forward mypod 0:3306

Lokal bilgisayarın 6379 portunu podun 6379 portuna yönlendirme

$ kubectl port-forward pods/redis-master-66574464-258hz 6379:6379

Lokal bilgisayarın 6379 portunu podun 6379 portuna yönlendirme

$ kubectl port-forward deployment/redis-master 6379:6379

Lokal bilgisayarın 8888 portunu podun 5762 portuna tüm adreslerden erişilecek şekilde yönlendirme

$ kubectl port-forward --address 0.0.0.0 pod/mongo-db 8888:5762

Lokal bilgisayarın 8080 portunu podun 5762 portuna belirli adreslerden erişilecek şekilde 
yönlendirme

$ kubectl port-forward --address localhost,10.153.40.102 pod/mongo-db 8080:5762