
```sh
kubectl version
kubectl version --short
kubectl version -short 
Client Version: v1.29.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Unable to connect to the server: dial tcp: lookup hort: no such host
#kubernetes'de bir sorun olup olmadığı kontrol edilir
kubectl cluster-info
Kubernetes control plane is running at https://kubernetes.docker.internal:6443
CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

kubectl get namespace
NAME              STATUS   AGE
default           Active   37d
kube-node-lease   Active   37d
kube-public       Active   37d
kube-system       Active   37d

kubectl get replicaset
No resources found in default namespace.

kubectl get nodes
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   37d   v1.29.1

kubectl get po
No resources found in default namespace.

kubectl get deployment, services
Error from server (NotFound): deployments.apps "services" not found

kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   37d


```


```sh
kubectl run myweb --image=nginx:latest
kubectl get pod myweb
kubectl describe pod myweb
kubectl delete pod myweb
kubectl logs myweb
kubectl exec -it myweb --bash
kubectl explain service
kubetctl apply --file myprojectfile.yml
```

```sh
kubectl get po
kubectl get pods
kubectl pod myweb
kubectl pod/myweb
#alias
k get pods

kubectl get no -o yaml 
apiVersion: v1
items:
- apiVersion: v1
  kind: Node
  metadata:
    annotations:
      kubeadm.alpha.kubernetes.io/cri-socket: unix:///var/run/cri-dockerd.sock
      node.alpha.kubernetes.io/ttl: "0"
      volumes.kubernetes.io/controller-managed-attach-detach: "true"
    creationTimestamp: "2024-03-30T08:29:56Z"
    labels:
      beta.kubernetes.io/arch: amd64
      beta.kubernetes.io/os: linux
      kubernetes.io/arch: amd64
      kubernetes.io/hostname: docker-desktop
      kubernetes.io/os: linux
      node-role.kubernetes.io/control-plane: ""
      node.kubernetes.io/exclude-from-external-load-balancers: ""
    name: docker-desktop
    resourceVersion: "26965"

#yaml dosyasi olusturma
kubectl get no -o yaml >> demo.yaml

kubectl explain pod
KIND:       Pod
VERSION:    v1

DESCRIPTION:
    Pod is a collection of containers that can run on a host. This resource is
    created by clients and scheduled onto hosts.

FIELDS:
  apiVersion    <string>
    APIVersion defines the versioned schema of this representation of an object.
    Servers should convert recognized schemas to the latest internal value, and
    may reject unrecognized values. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources

kubectl get nodes -o wide
NAME             STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION                       CONTAINER-RUNTIME
docker-desktop   Ready    control-plane   37d   v1.29.1   192.168.65.3   <none>        Docker Desktop   5.15.146.1-microsoft-standard-WSL2   docker://26.0.0
```

# Hello World

```sh
kubectl run k8s-pod-1 --image=hello-world

kubectl get pod
NAME        READY   STATUS             RESTARTS     AGE
k8s-pod-1   0/1     CrashLoopBackOff   1 (2s ago)   9s
kubectl describe po k8s-pod-1 
Name:             k8s-pod-1
Namespace:        default
Priority:         0
Service Account:  default
Node:             docker-desktop/192.168.65.3
Start Time:       Tue, 07 May 2024 08:14:49 +0300
Labels:           run=k8s-pod-1
Annotations:      <none>
Status:           Running
IP:               10.1.0.22
IPs:
  IP:  10.1.0.22
Containers:
  k8s-pod-1:
    Container ID:   docker://4146d4c032009dabce25bd085b01e415dfcd93715973d1f6e34b69f1ec52f7a1
    Image:          hello-world
    Image ID:       docker-pullable://hello-world@sha256:a26bff933ddc26d5cdf7faa98b4ae1e3ec20c4985e6f87ac0973052224d24302
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Tue, 07 May 2024 08:15:36 +0300
      Finished:     Tue, 07 May 2024 08:15:36 +0300


# pod servisini ayağa kaldirmak icin 5 sefer restart etmis
kubectl get pod
NAME        READY   STATUS      RESTARTS      AGE
k8s-pod-1   0/1     Completed   5 (94s ago)   3m3s

#bu restart ozelligini kapatmak icin asagidaki gibi parametre belirtilir (--restart=Never/ Always / On-Failure)

kubectl run k8s-pod-2 --image=hello-world --restart=Never 
kubectl get pod
NAME        READY   STATUS             RESTARTS        AGE
k8s-pod-1   0/1     CrashLoopBackOff   6 (4m56s ago)   10m
k8s-pod-2   0/1     Completed          0               4m1s

kubectl delete po --all 
pod "k8s-pod-1" deleted
pod "k8s-pod-2" deleted
```


