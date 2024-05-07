alias (takma ad) Kullanımın Önemi
Özel kullanımda yada CKA sertifika sınavında kısaltma kullanarak iş yapmak oldukça önemlidir. Bildiğiniz gibi CKA Sertifika sınavında sizlere 2 saatlik bir zaman dilimi verilir ve verilen LAB örneklemesini yapmanız beklenir. Her komutu uzun uzun yazıp zaman kaybetmek yerine başlangıçta en çok kullanılacak komutları takma isim vererek kısaltıp kullanabilirsiniz. Böylece komutu her seferinde uzun uzun yazıp zaman kaybetmek yerine hızlıca çıktıya erişebilirsiniz.

Örnek Kullanım:

alias k='kubectl'

alias kg='kubectl get'

alias kgpo='kubectl get pod'

alias kdp='kubectl describe pod'

alias kd='kubectl delete'

alias kdf='kubectl delete -f'

alias ke='kubectl explain'

alias kgl='kubectl get pods --show-labels'

alias ks='kubectl get namespaces'

alias kga='kubectl get pod --all-namespaces'

alias kgla='kubectl get all --show-labels'

alias c='clear'

alias kdr='kubectl run --dry-run=client -o yaml'

alias kd="kubectl delete --grace-period=0 --force"



Yukarıda Linux işletim sistemi için örnek oluşturulmuş kısaltmalar yer almaktadır. Sizde kendinize göre bir standart belirleyerek bu kısaltmaları kullanabilirsiniz. 