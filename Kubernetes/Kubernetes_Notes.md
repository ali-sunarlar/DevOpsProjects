Master - Control Plane

Etcd

(kalıcı storage) etcd cluster'ınızdaki (master ve worker'larin)state durumunu tutar. Servislerin, replica set'lerin state bilgisini veya tüm objelerin state bilgisini tutar. Yuksek erişilebilirlik(HA), tutarlilik ve izlenebilirlik ozelliklerine sahip daginik mimari ile tasarlanmis ve tum cluster verilerinin saklandigi bilesendir. Coreos tarafindan olusturulmus acik kaynakli key valus database'dir

Api Server(k8s beyni)

Bütün bilesenlerin haberlesmesini saglar. İstekleri gerekli node'a , scheduler'a veya etcd'ye iletir. Çalışmazsa ortam fail alır. Hiçbir işlem yapılamaz. Node çalışabilir yalnız ortamın bütünü yönetilemez

Controller Manager

Bizim ortamımızdaki bütün katmanların yönetilmesinden sorumludur. Deployment'lar replica set'ler. Worker'lar master set'lerin kontrolünü sağlar. MaSTER NODE uzerinde bulunan kontrolcüleri yoneten birimdir. Kontrol merkezi olarak gorev alir ve tum nesneleri denetler. Gecerli durum ile istenen durumu izler.

|Controller|Gorevi|
|--|--|
| Node Controller | Node'larin ayakta olup olmadigini kontrolunu yapar |
| Replication Controller| Pod'larin olmasi gereken kopya sayisinda olup olmadigini kontrol eder ve eger fail olan pod varsa gerekli sayiya ceker |
| Endpoints Controller | Pod ve service'lerin Endpoint'lerini olsturmak icin kullanilir. |
| Service Account & Token Controllers | Yeni namespaceler icin standart hesaplari ve PI Access tokenlari olustusmaktadir. |

Scheduler

Bizim node'larin pod'larin oluşturulmasından sorumludur. Pod'larin hangi node uzerinde calistirilacagina karar veren komponentdir. Pod'un ihtiyac duydugu CPU ve RAM hangi node uzerinde musatise o node uzerinde pod olusturulur.

ornek olarak kubectl run denilirse ilk olarak bu istek Api server'a gider Api server etcd'ye iletir. Etcd böyle bir kayit var mi yok mu kontrol edilir sonra tekrar Api server'a iletir. Api Server controller manager'a iletir hangi node'larin müsait olduğu bilgisini alir ve scheduler'a iletir ilgili pod'u create ederek çıktısını Api server'a iletir.



Node - Worker

Pod'larin calismis oldugu yapi

kubelet

Node üzerinde kurulu olan agent bileşeni. Master ve worker arasindaki iletişimi sağlayan bileşendir. Master nodeun worker node uzerinde calisan ajanidir. Her worker node kubelete bilesenini barindirir. Docker servisi ile konusarak pod'u ayaga kaldirir ve bunun bilgisini API server'a iletir.

k-proxy(kubeproxy)

hem master - worker arasindaki network tragini yöneten hem de  node üzerindeki çalışan pod networkünü yöneten bileşen (Pod'un ip almasini saglayan pod'larin haberlesmesini saglayan bileşendir). Kubernetes uzerindeki network islemlerinden sorumludur. Pod'lara ip adresi verilmesi ve service load balance islemlerini yonetir. Kubernetes de pod icerisindeki tum container'lar tek ip'yi paylasir.


Container Engine(Runtime)

Bütün node'larda olmasi gereken en temel bileşenlerdendir. Conatainer'larin calismasindan sorumlu ola bilesendir. Image'lari registry uzerinden ceker ve container'i olusturur. Akabinde start, stop, delete islemlerini yapar.

Kubernetes Nesneleri(Uygulamimizi calistirmak, Olceklendirmek ve yonetmek icin olusturulmus kalici varliklardir)

Pod

Namespaces

ReplicationController

Replicaset

Deployment

Service

StatefulSet

DeamonSet


Swap olmaması önerilir

```sh
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

```

hostname değişiklikleri
```sh
hostnamectl set-hostname k8smaster01
hostnamectl set-hostname k8smaster02
hostnamectl set-hostname k8smaster03
hostnamectl set-hostname k8sworker01
hostnamectl set-hostname k8sworker02
hostnamectl set-hostname k8sworker03

hostnamectl set-hostname rockymaster01
hostnamectl set-hostname k8smaster02
hostnamectl set-hostname k8smaster03
hostnamectl set-hostname rockyworker01
hostnamectl set-hostname k8sworker02
hostnamectl set-hostname k8sworker03
```

IP-Hostname 
```sh
[root@rocky ~]# vi /etc/hosts

192.168.2.131 k8smaster01
192.168.2.133 k8smaster02
192.168.2.128 k8smaster03
192.168.2.132 k8sworker01
192.168.2.130 k8sworker02
192.168.2.134 k8sworker03

192.168.2.131 rockymaster01
192.168.2.133 rockymaster02
192.168.2.128 rockymaster03
192.168.2.132 rockyworker01
192.168.2.130 rockyworker02
192.168.2.134 rockyworker03
```

Kubernetes cluster'lar Overlay - MACoverlay network'unde çalıştır ve aktif ediliyor.(Overlay özelliği aktif ediliyor)
```sh
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

```sh
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

modprobe için aktif ediliyor
```sh
modprobe overlay
modprobe br_netfilter
```

```sh
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
```

```sh
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
```


bu işlemler bütün node'lar yapılması gerekir
```sh
sysctl --system
```

```sh
dnf update -y
```

```sh
apt-get update
```


```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

kubectl version --client

kubectl version --client --output=yaml


```

https://v1-28.docs.kubernetes.io/docs/tasks/tools/install-kubectl-linux/

ubuntu
```sh
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update && apt-get upgrade

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet
```

```sh
# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF
```


Install kubectl using yum:
```sh
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
```

If you are on Linux and using Homebrew package manager, kubectl is available for installation.
```sh
sudo yum install procps-ng curl file git
```


```sh
brew install kubectl
kubectl version --client
```

```sh
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sestatus
```


```sh
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10259/tcp
sudo firewall-cmd --permanent --add-port=10257/tcp
sudo firewall-cmd --permanent --add-port=179/tcp
sudo firewall-cmd --permanent --add-port=4789/udp
```


```sh
sudo firewall-cmd --permanent --add-port=179/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=30000-32767/tcp
sudo firewall-cmd --permanent --add-port=4789/udp
```


```sh
sudo firewall-cmd --reload
```


```sh
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io -y
```

ubuntu
```sh
apt-get install docker.io
```

containerd klasörü oluşturuyoruz. Yapilandirmayla ilgili bilgilerimizi tutacak. config default dosyasi oluşturuyoruz. Zaten varsa oluşturuyoruz.
```sh
sudo mkdir /etc/containerd

sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak

sudo sh -c "containerd config default > /etc/containerd/config.toml"

sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml


```

config yapilandirmalari sonrasi servisleri restart ediyoruz ve enable yapıyoruz.
```sh
systemctl restart containerd.service
systemctl restart kubelet.service

systemctl enable --now kubelet.service
systemctl enable --now containerd.service
```

kubeadm yöntemi kullanıyoruz. Image'lari pull ediyoruz
```sh
sudo kubeadm init --control-plane-endpoint=rockymaster01 --pod-network-cidr=10.10.0.0/16

kubeadm config images pull
```

tüm pod'lar ayri bir bridge network üzerinden haberleşmesi gerekiyor
```sh
sudo kubeadm init --pod-network-cidr=10.10.0.0/16
```


```sh
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.2.131:6443 --token nmjtaw.4odcpohubso6x0mb \
        --discovery-token-ca-cert-hash sha256:007a30990d6bed345c100867cbb7e12a93d205cb51a83c882b3e9bdb22979a7f

#yeni bir token oluşturma
[root@k8smaster01 ~]# kubeadm token create --print-join-command
kubeadm join 192.168.2.131:6443 --token ojaf3e.4bju16di7zq40kgd --discovery-token-ca-cert-hash sha256:007a30990d6bed345c100867cbb7e12a93d205cb51a83c882b3e9bdb22979a7f

#mevcut token'lari listeleme
[root@k8smaster01 ~]# kubeadm token list
TOKEN                     TTL         EXPIRES                USAGES                   DESCRIPTION                                                EXTRA GROUPS
nmjtaw.4odcpohubso6x0mb   22h         2024-04-01T11:54:17Z   authentication,signing   The default bootstrap token generated by 'kubeadm init'.   system:bootstrappers:kubeadm:default-node-token
ojaf3e.4bju16di7zq40kgd   23h         2024-04-01T13:02:01Z   authentication,signing   <none>                                                     system:bootstrappers:kubeadm:default-node-token


[root@k8smaster01 ~]# mkdir -p $HOME/.kube
[root@k8smaster01 ~]# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[root@k8smaster01 ~]# sudo chown $(id -u):$(id -g) $HOME/.kube/config
[root@k8smaster01 ~]# export KUBECONFIG=/etc/kubernetes/admin.conf
```

```sh
[root@k8smaster01 ~]# kubectl get nodes
NAME          STATUS     ROLES           AGE     VERSION
k8smaster01   NotReady   control-plane   2m36s   v1.28.8

[root@rockymaster01 ~]# kubectl get nodes
NAME            STATUS   ROLES           AGE   VERSION
rockymaster01   Ready    control-plane   13m   v1.29.3
```

calico kurulumu. Overlay çalıştığımız için network plugin'lerinin yüklenmesi gerekir. calico seçilmiştir farkli plugin'ler kurulabilir.

calico (overlay)

flannel (overlay)

weave Net (overlay)

cillium (overlay)

contiv(overlay)




```sh
[root@k8smaster01 ~]# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
namespace/tigera-operator created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/apiservers.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/imagesets.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
serviceaccount/tigera-operator created
clusterrole.rbac.authorization.k8s.io/tigera-operator created
clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
deployment.apps/tigera-operator created



[root@k8smaster01 ~]# kubectl get all --all-namespaces
NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE
kube-system       pod/coredns-5dd5756b68-6tbbp              0/1     Pending   0          6m46s
kube-system       pod/coredns-5dd5756b68-zfqb2              0/1     Pending   0          6m46s
kube-system       pod/etcd-k8smaster01                      1/1     Running   0          6m57s
kube-system       pod/kube-apiserver-k8smaster01            1/1     Running   0          6m57s
kube-system       pod/kube-controller-manager-k8smaster01   1/1     Running   0          6m57s
kube-system       pod/kube-proxy-wf6pz                      1/1     Running   0          6m46s
kube-system       pod/kube-scheduler-k8smaster01            1/1     Running   0          6m57s
tigera-operator   pod/tigera-operator-748c69cf45-lcsg7      1/1     Running   0          2m3s

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  7m7s
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   7m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   7m

NAMESPACE         NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
kube-system       deployment.apps/coredns           0/2     2            0           7m
tigera-operator   deployment.apps/tigera-operator   1/1     1            1           2m3s

NAMESPACE         NAME                                         DESIRED   CURRENT   READY   AGE
kube-system       replicaset.apps/coredns-5dd5756b68           2         2         0       6m46s
tigera-operator   replicaset.apps/tigera-operator-748c69cf45   1         1         1       2m3s
```

```sh
[root@k8smaster01 ~]# kubectl get all --all-namespaces -o wide
NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE     IP              NODE          NOMINATED NODE   READINESS GATES
kube-system       pod/coredns-5dd5756b68-6tbbp              0/1     Pending   0          61m     <none>          <none>        <none>           <none>
kube-system       pod/coredns-5dd5756b68-zfqb2              0/1     Pending   0          61m     <none>          <none>        <none>           <none>
kube-system       pod/etcd-k8smaster01                      1/1     Running   0          61m     192.168.2.131   k8smaster01   <none>           <none>
kube-system       pod/kube-apiserver-k8smaster01            1/1     Running   0          61m     192.168.2.131   k8smaster01   <none>           <none>
kube-system       pod/kube-controller-manager-k8smaster01   1/1     Running   0          61m     192.168.2.131   k8smaster01   <none>           <none>
kube-system       pod/kube-proxy-fx4lp                      1/1     Running   0          3m50s   192.168.2.132   k8sworker01   <none>           <none>
kube-system       pod/kube-proxy-wf6pz                      1/1     Running   0          61m     192.168.2.131   k8smaster01   <none>           <none>
kube-system       pod/kube-scheduler-k8smaster01            1/1     Running   0          61m     192.168.2.131   k8smaster01   <none>           <none>
tigera-operator   pod/tigera-operator-748c69cf45-lcsg7      1/1     Running   0          56m     192.168.2.131   k8smaster01   <none>           <none>

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE   SELECTOR
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  61m   <none>
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   61m   k8s-app=kube-dns

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE   CONTAINERS   IMAGES                               SELECTOR
kube-system   daemonset.apps/kube-proxy   2         2         2       2            2           kubernetes.io/os=linux   61m   kube-proxy   registry.k8s.io/kube-proxy:v1.28.8   k8s-app=kube-proxy

NAMESPACE         NAME                              READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS        IMAGES                                    SELECTOR
kube-system       deployment.apps/coredns           0/2     2            0           61m   coredns           registry.k8s.io/coredns/coredns:v1.10.1   k8s-app=kube-dns
tigera-operator   deployment.apps/tigera-operator   1/1     1            1           56m   tigera-operator   quay.io/tigera/operator:v1.32.5           name=tigera-operator

NAMESPACE         NAME                                         DESIRED   CURRENT   READY   AGE   CONTAINERS        IMAGES                                    SELECTOR
kube-system       replicaset.apps/coredns-5dd5756b68           2         2         0       61m   coredns           registry.k8s.io/coredns/coredns:v1.10.1   k8s-app=kube-dns,pod-template-hash=5dd5756b68   
tigera-operator   replicaset.apps/tigera-operator-748c69cf45   1         1         1       56m   tigera-operator   quay.io/tigera/operator:v1.32.5           name=tigera-operator,pod-template-hash=748c69cf45

[root@k8smaster01 ~]# kubectl get nodes -o wide
NAME          STATUS     ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                      KERNEL-VERSION                 CONTAINER-RUNTIME
k8smaster01   NotReady   control-plane   10m   v1.28.8   192.168.2.131   <none>        Rocky Linux 9.3 (Blue Onyx)   5.14.0-362.24.1.el9_3.x86_64   containerd://1.6.28
```

```sh
kubectl get node - # node listesini verir

kubectl get node -o wide # detayli node listesini verir

kubectl cluster-info #cluster durum bilgisi

[root@k8smaster01 ~]# kubectl cluster-info
Kubernetes control plane is running at https://192.168.2.131:6443
CoreDNS is running at https://192.168.2.131:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

kubectl config view # config çıktısını verir

[root@k8smaster01 ~]# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.2.131:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED

kubectl get pods (po) #ortamda calisan pod listesi

[root@k8smaster01 ~]# kubectl get pods
No resources found in default namespace.

[root@k8smaster01 ~]# kubectl get pods -n kube-system
NAME                                  READY   STATUS    RESTARTS   AGE
coredns-5dd5756b68-6tbbp              0/1     Pending   0          78m
coredns-5dd5756b68-zfqb2              0/1     Pending   0          78m
etcd-k8smaster01                      1/1     Running   0          78m
kube-apiserver-k8smaster01            1/1     Running   0          78m
kube-controller-manager-k8smaster01   1/1     Running   0          78m
kube-proxy-fx4lp                      1/1     Running   0          20m
kube-proxy-wf6pz                      1/1     Running   0          78m
kube-scheduler-k8smaster01            1/1     Running   0          78m

kubectl get ns # namespace'leri listeler. Uygulamalarin calistigi katmandir. İzalasyon icin kullanilir

[root@k8smaster01 ~]# kubectl get ns
NAME              STATUS   AGE
default           Active   79m
kube-node-lease   Active   79m
kube-public       Active   79m
kube-system       Active   79m
tigera-operator   Active   74m

```

```sh
[root@rockymaster01 ~]# kubectl get nodes
NAME            STATUS   ROLES           AGE   VERSION
rockymaster01   Ready    control-plane   50m   v1.29.3
rockyworker01   Ready    <none>          89s   v1.29.3
[root@rockymaster01 ~]# kubectl get pods -n kube-system
NAME                                    READY   STATUS              RESTARTS   AGE
coredns-76f75df574-q48xd                0/1     ContainerCreating   0          51m
coredns-76f75df574-wj7xk                0/1     ContainerCreating   0          51m
etcd-rockymaster01                      1/1     Running             0          51m
kube-apiserver-rockymaster01            1/1     Running             0          51m
kube-controller-manager-rockymaster01   1/1     Running             0          51m
kube-proxy-j2fnn                        1/1     Running             0          51m
kube-proxy-ljl7x                        1/1     Running             0          118s
kube-scheduler-rockymaster01            1/1     Running             0          51m
[root@rockymaster01 ~]# kubectl get ns
NAME              STATUS   AGE
default           Active   51m
kube-flannel      Active   41m
kube-node-lease   Active   51m
kube-public       Active   51m
kube-system       Active   51m
tigera-operator   Active   47m
```

pod oluşturma
```sh
[root@rockymaster01 ~]# kubectl run mypod01 --image nginx
pod/mypod01 created
[root@rockymaster01 ~]# kubectl get po
NAME      READY   STATUS              RESTARTS   AGE
mypod01   0/1     ContainerCreating   0          40s


[root@rockymaster01 ~]# kubectl describe pod mypod01
Name:             mypod01
Namespace:        default
Priority:         0
Service Account:  default
Node:             rockyworker01/192.168.2.138
Start Time:       Sun, 31 Mar 2024 21:55:45 +0300
Labels:           run=mypod01
Annotations:      <none>
Status:           Pending
.
.
.
   TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300
```

impretivly metod(test ortamlarinda kullanilir)

```sh
kubectl run mypod01 --image nginx 
```

objeler oluşturma yaml manifest dosylari oluşturulur. declatirive metod-mod


```yaml
apiVersion: v1
kind: Pod
metadata:
 name: mypod01
spec:
 containers:
 - name: webserser01
   image: nginx:latest
   ports:
   - containerPort: 80
   resources:
   requests:
    memory: "128Mi"
    cpu: "100m" #veya 0.1 yazilabilir
   limits:
    memory: "256Mi"
    cpu: "250m" #0.25
   livenessPrope: #eger cevap geliyor basarili sayar
    httpGet:
     path: /
     port: 80
     initialDelaySeconds: 30 #30 saniye beklemenin ardindan testi baslatir
     periodSeconds: 15 # her 15 saniye tekrarlar
     timeoutSeconds: 10 # 10 saniye sonunda cevap alinmazsa timeout verir
     failureTheshold: 3 # 3 defa hatalinirsa failure verir
   readinessProbe:
    httpGet:
    path: /trafik_kabul
    port: 80
   initialDelaySeconds: 40
```



```sh
root@k8smaster01:~# sudo kubeadm init --control-plane-endpoint=k8smaster01 --pod-network-cidr=10.10.0.0/16
[init] Using Kubernetes version: v1.29.3
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0331 19:51:04.332853    4421 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8smaster01 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.2.137]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8smaster01 localhost] and IPs [192.168.2.137 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8smaster01 localhost] and IPs [192.168.2.137 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 16.506513 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8smaster01 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node k8smaster01 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: lakns8.1hzfhxndzlcxfuyr
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join k8smaster01:6443 --token lakns8.1hzfhxndzlcxfuyr \
        --discovery-token-ca-cert-hash sha256:7c250dccd7119e2e2ff7832e44fad48194fcde478341d653abde871bf71798cb \
        --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8smaster01:6443 --token lakns8.1hzfhxndzlcxfuyr \
        --discovery-token-ca-cert-hash sha256:7c250dccd7119e2e2ff7832e44fad48194fcde478341d653abde871bf71798cb
```



API Server'a islem yaptirma yontemleri

1-  REST API Commands

2-  UI uzerinden islem yapma (Dashboard). Her islem buradan yapilamıyor

3-  Kubectl uzerinden islem yapma


Label ve Selector

POD, RS çok fazla oldugundan ne isi yaptigini belirten etiket belirtilir

POD
app:production

rel:backend

POD
app:ui
ver:beta15

|Label|
|--|
|Etiketler Kubernetes nesnelerine eklenir ve anahtar değer bilgisinden oluşur|
|Etiketler kubernetes üzerinde nesnelerin tanımlamasına ve gruplar halinde düzenlenmesini sağlar | 
|Etiketler, nesne oluşturulurken yada çalışma anında eklenebilir veya değiştirilebilir |
|Her etiket belirli bir nesne grubu için benzersiz olmalıdır |
|Prefix “önek” kısmı opsiyoneldir. Zorunlu değildir. |
|Etiket adı ve değeri 63 karakterle sınırlıdır. |
|a-2-A_2-0-9 izin verilen karakterlerdir |
|Key ve değer harf ile başlamalı ve bitmelidir |


Selector

etiketledigimiz nesneleri bulup islem yaptirmak istedigimizde kullandigimiz bir tanimdir.

Dısaridan gelen kullanici taleplerini ilgili etikete sahip pod'lara load balance edilmesinde kullaniriz.


| Selector |
|--|
|Selector, kubernetes üzerindeki nesneleri aramak için kullanılmaktadır|
|Eavality-based ve set-based şeklinde iki farklı türü bulunmaktadır.|
|Birden fazla kriter varsa bunlar (.) virgül ile ayrılmaktadır|
|Etiket arama kriterine kesinlikle uyulmalıdır |



Namespace

Kubernetes içerisinde ki POD'ları veya objeleri ayirmamiza/gruplandirmamiza imkan sağlayan teknolojidir. Kubernetes cluster içerisinde farklı virtual cluster alanları oluşturmak için kullanılmaktadır 

her proje icin ayri olusturulan klasore benzetebiliriz

|Namespace|
|--|
|Kubernetes içerisindeki objeleri ayırmamıza gruplamamıza imkan sağlayan teknolojidir |
|Kubernetes ilk kurulduğunda 4 namespace dahili olarak gelmektedir.
  • default
  • kube-system
  • kube-public
  • Kube-node-lease|
|Namespacelar sayesinde cluster kaynakları farklı projeler için bölünebilmektedir |
|Namespace isimleri birbirinden benzersiz olmak zorundadır |