apiVersion:(Kubernetes API Sürümünü Tanımlar)
Kind:Nesne Türünü Tanımlar(Pod/ReplicationController/Service/ReplicaSet/Deployment/DaemonSet/Job)
metadata:(Nesneyle ilgili Benzersiz Olan Tanımlamalar- İsim, Namespace)
spec: (Oluşturulacak Nesneyle İlgili Durum Detaylarını Tanımlar)



```yml
apiVersion: v1
kind: Pod
metadata: 
 name: nginx-pod-first

spec: 
 containers:
  - name: web
    image:nginx:latest:
     ports:
      - containerPort: 80
```

--field-selector

kubectl get pods --field-selector metadata.name=myApp

kubectl get pods --field-selector metadata.namespace=production

kubectl get pods --field-selector metadata.namespace!=Project

kubectl get services --all-namespaces --field-selector metadata.namespace!=default

kubectl get pods --field-selector status.phase=Running

kubectl get pods --field-selector=status.phase!=Running,spec.restartPolicy=Always

oluşturmak ve güncellemek için apply kullanilir. Create sadece oluşturmak için

kubectl create --filename my-manifest-1.yaml

kubectl apply --filename my-manifest-1.yaml

kubectl apply -f my-manifest-2.yaml

kubectl apply -f ./my1.yaml -f ./my2.yaml 

kubectl apply -f https://git.io/vPieo

```sh
 kubectl apply -f .\pod-hello.yaml
 kubectl logs pod-hello-world
 ______________________________________
/ Hello, l am Rex. Do you learn        \
| Kubernetes? Happy learning time with |
\ Mr. Aksu!!                           /
 --------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

| Kubernetes ismi | Docker ismi | Açıklama |
| -- | -- | -- |
| command | Entypoint | Container tarafindan calistirilan komut. |
| args | cmd | Command'e iletilen argumanlar |

```yml
command:
 - /bin/entrypoint.sh
```

```yml
command: ["date"]
args: ["-u"]
```

```yml
command: ["printenv"]
args: ["HOSTNAME", "KUBETNETES_PORT"]
```

```yml
command: ["/bin/sh"]
args: ["-c", "while true; do echo hello; sleep 10;done"]
```

❑Multi-Container kullanımı aynı pod içerisinde birden fazla konteyner oluşturmamıza imkan
vermektedir

❑ Pod içerisinde ki her iki konteyner tek bir koteynermış gibi hareket eder, oluşturulunca
birlikte oluşturulur , silinince birlikte silinirler

❑ Her iki konteyner birbirleriylelocalhost seviyesinde iletişimegeçmektedir

❑ Tek bir volume oluşturup her iki konteyner üzerine bağlanabilir ve kullanılabilir
