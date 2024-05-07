Dosya ve dizinleri pod’a veya pod’dan dosyaya kopyalama 
# kubectl cp <file-spec-src> <file-spec-dest>
/tmp/foo dizini pod’a kopyama sentaksı
# kubectl cp /tmp/foo <some-namespace>/<some-pod>:/tmp/bar
Pod içerisindeki /tmp/foo dizini lokal bilgisayarın /tmp/bar içerisine kopyalama sentaksı
# kubectl cp <some-namespace>/<some-pod>:/tmp/foo /tmp/bar
password.txt dosyasını pod’un tmp dosyasına içerisine kopyalama
# kubectl cp password.txt k8s-cp-1:tmp/
Lokal dizindeki tüm dosyaları pod içerisine kopyalama
# kubectl cp . k8s-cp-1:/tmp/store
Pod içerisindeki index.html dosyasını lokal bilgisayarın tmp altına kopyalama
# kubectl cp apache-pod:index.html /tmp
Pod içerisindeki index.html dosyasını lokal bilgisayarın tmp altına kopyalama
# kubectl cp apache-pod:/var/www/html/index.html /tmp