Clusterdaki nodeları Label’ları ile birlikte listeler

kubectl get no --show-labels

Default namespacedeki podları Label’ları ile birlikte listeler

kubectl get po --show-labels

Nginx image’ını kullanan my-web isimli podu label ataması yaparak oluştur/başlat

kubectl run my-web --image=nginx --labels="env=prod,tier=frontend"

Çalışan my-web isimli pod üzerine “tier=backend” label etiketi ekle

kubectl label pods my-web tier=backend

Çalışan my-web isimli pod üzerinde tanımlı “tier” etiketini değiştirme

kubectl label pods my-web tier=frontend --overwrite

Default namespace üzerindeki tüm podlar üzerine “status=healthy” etiketini ekle

kubectl label pods --all status=healthy

emea.internal isimli node üzerine “disktype=ssd” etiketini ekle

kubectl label nodes emea.internal disktype=ssd

Etiketi “env=prod” olan podları listele

kubectl get po --selector="env=prod"

Etiketi “env=prod” olmayan podları listele

kubectl get po --selector="env!=prod"

Etiketi “env=prod,tier=backend” olan podları listele

kubectl get po -l "env=prod,tier=backend"

Etiketi “env=prod” olan podları listele

kubectl get po -l "env in (prod)"

Etiketi “env=prod,tier=backend” olan podları listele

kubectl get po -l "env in (prod),tier in (backend)"

Etiketi “env=prod,env=demo” olan podları listele

kubectl get po -l "env in (prod,demo)"

Etiketi “env=demo” olan podları sil

kubectl delete pods -l "env=demo"

Etiketi "env=prod,tier=backend"olan podları sil

kubectl delete pods -l "env in (prod),tier in (backend)"


kubectl get namespace mynamespace --show-labels