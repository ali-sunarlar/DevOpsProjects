# Azure AKS ile GitOps & Progressive Delivery Altyapısı
## (ArgoCD, Argo Rollouts & Canary Deployment Lab)

Bu proje, Azure Kubernetes Service (AKS) üzerinde manuel operasyonları tamamen ortadan kaldıran, altyapıyı kod olarak yöneten (**GitOps**) ve canlı ortama sürüm güncellemelerini sıfır kesintiyle (**Zero-Downtime**) alan kurumsal bir mimari laboratuvarıdır.

Klasör içi tüm otomasyon, lokal makineyi kirletmeden tamamen bulut tabanlı kaynaklar üzerinde (Azure Sandbox) çalışacak şekilde **PowerShell Core** ve **Bash** scriptleri ile modüler hale getirilmiştir.

---

## 🛠️ Mimari Bileşenler & Teknolojiler

* **Platform:** Azure Kubernetes Service (AKS) - `Standard_B2s` Node Pool
* **GitOps Motoru:** ArgoCD (Pull-Based Eşitleme ve Hata İyileştirme)
* **Progressive Delivery:** Argo Rollouts (Gelişmiş Trafik Bölme & Canary)
* **Dış Ağ Kapısı:** Azure Standart LoadBalancer (Public IP: `20.253.234.64`)
* **Otomasyon:** PowerShell 7.6+ Core (Linux Uyumlu Dağıtım Scriptleri)

---

## 🚀 Lab Ortamı Kurulum Adımları

### 1. Ön Gereksinimler & Lokal Giriş
Lokal Linux makineniz üzerinden Azure entegrasyonunu başlatın:
```bash
az login
```

### 2. Master Script ile Altyapıyı Sıfırdan Ayağa Kaldırma

Proje klasöründeki tek tıkla kurulum scriptini (install.ps1) tetikleyin. Bu script dinamik Sandbox Resource Group adını otomatik bulur, AKS kümesini açar, kubeconfig anahtarlarını birleştirir ve Argo ailesini (ArgoCD + Rollouts) küme içine enjekte eder:

```bash
pwsh ./install.ps1
```

### 3. Bulut Üzerindeki ArgoCD Paneline Erişim

Azure LoadBalancer üzerinden atanan Public IP adresini sorgulayın ve tarayıcınızdan https://<EXTERNAL-IP> adresiyle panele bağlanın:

```bash
kubectl get svc argocd-server -n argocd
```

Kullanıcı Adı: admin

İlk Kurulum Şifresini Çözme:


```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### Uygulanan Dağıtım Stratejisi: Canary Deployment

Kubernetes'in yerleşik RollingUpdate mekanizması trafiği yüzdesel olarak bölemediği için (Örn: "Trafiğin sadece %10'u yeni sürüme gitsin" diyemeyiz), bu kısıtlamayı aşmak amacıyla Argo Rollouts entegrasyonu yapılmıştır. muhasebe-canary.yaml şablonu ile 4 replikalı bir yapıda kademeli sızma ve geçiş testi uygulanır.
Kurumsal Canary Aşamaları:

%10 Aşaması (Güvenli Sızma): Gelen kullanıcı isteklerinin sadece %10'u yeni v2 sürümüne aktarılır. Sistem tam 1 dakika boyunca (pause: 1m) duraklayarak siber güvenlik ve yazılım ekiplerinin logları/hata kodlarını incelemesine izin verir.

%50 Aşaması (Gözlem): Her şey kararlı ilerliyorsa trafik otomatik olarak yarı yarıya (%50) bölünür ve gözlem süreci devam eder.

%100 Aşaması (Final): Tam kararlılık sağlandığında eski v1 podları sistemden temizlenerek tüm kurumsal yük v2 sürümüne sıfır kesintiyle kaydırılır.

### Canary Test ve Sürüm Güncelleme Komutları:

Sürüm geçiş testlerini tetiklemeden önce ve tetikleme anında kullanılacak canlı operasyon komutları:


```bash
# Adım 1: Canlı terminal izleme panelini açın (Bu ekran açık kalarak süreci grafiksel izletir)
kubectl argo rollouts get rollout muhasebe-web-rollout --watch

# Adım 2: Yazılım ekibinin v2 güncellemesini tetikleyin (Joker karakter kullanımı)
kubectl argo rollouts set image rollout muhasebe-web-rollout *=nginx:1.26-alpine

# Alternatif GitOps Yöntemi: Dosya içindeki imajı güncelleyip şablonu yeniden üfleyin
kubectl apply -f ./muhasebe-canary.yaml
```

### 🔒 Güvenlik & Mimari Notları (GitOps Gücü)

    Pull-Based Mimari (Güvenli Kapı): Küme, dış dünyadaki CI/CD araçlarına (Jenkins, GitLab vb.) hassas yönetici şifrelerini (kubeconfig) sızdırmaz. Küme içindeki ArgoCD, GitHub'ı güvenli bir kanaldan dinler ve kodları içeriye kendi çeker.

    Self-Healing (Kendi Kendini İyileştirme): Canlı ortamda (Live State) herhangi bir kullanıcı veya saldırgan manuel olarak pod ayarlarını değiştirirse veya bir nesneyi silerse; ArgoCD bunu saniyeler içinde OutOfSync olarak yakalar, Git'teki orijinal kodu (Target State) baz alarak canlı ortamı otomatik olarak düzeltir ve yeşil (Synced) faza çeker.










