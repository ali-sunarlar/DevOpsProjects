# Project Aegis-Link (Zero-Trust Service Mesh & Distributed Tracing)

## 📌 Modül Amacı
Bu modül, mikroservis mimarilerinde servisler arası iletişimin güvenliğini (Zero-Trust) sağlamak ve dağıtık sistemlerdeki gecikme (latency) problemlerini uçtan uca izlemek amacıyla tasarlanmıştır.

---

## 🔐 1. Istio mTLS ve Ağ Güvenliği (`istio_security/`)
* **`peer-authentication.yaml`**: `STRICT` modda mTLS'i zorunlu kılarak podlar arası trafiği şifreler.
* **`istio-auth-policy.yaml`**: Servis bazlı RBAC (Role-Based Access Control) kuralları uygular. `payment-service` sadece `order-service` servisinin POST isteklerini kabul eder.

## 📊 2. Uçtan Uca Gözetilebilirlik (`tracing_observability/`)
* **`jaeger-telemetry.yaml`**: Istio veri düzlemini (data plane) Jaeger/OpenTelemetry altyapısına bağlar. Uygulama kodunda değişiklik yapmadan ağ seviyesindeki tüm gecikmeleri görselleştirir.

---
🌐 **Cloud Native Security & Observability Engineering Module**


## . Adım: Sandbox İçinde AKS Kümesini Oluşturma

Sandbox ortamının kaynak kısıtlamalarına takılmamak ve hızlı ayağa kalkmasını sağlamak için 2 node'lu, hafif (Standard_B2s veya Standard_D2s_v5) bir küme oluşturuyoruz:
```Bash
# Sandbox bölgeni doğrulamak veya varsayılan olarak westeurope/eastus kullanmak için:
# (Genelde bu tip hazır sandbox'lar tek bir bölgeyi destekler, westeurope deneyelim)

az aks create \
  --resource-group 1-ec7dcc9a-playground-sandbox \
  --name hydra-aks-cluster \
  --node-count 2 \
  --node-vm-size Standard_B2s \
  --generate-ssh-keys \
  --edge-zone ""
```


### 🔑 2. Adım: Küme Bağlantısını (Credentials) Local'e Çekme

Küme Succeeded durumuna geçtiği an, local terminalimizin (kubectl ve istioctl) bu kümeyle konuşabilmesi için yetki anahtarlarını alalım:
```Bash
az aks get-credentials \
  --resource-group 1-ec7dcc9a-playground-sandbox \
  --name hydra-aks-cluster \
  --overwrite-existing
```


### 🚀 3. Adım: Istio Kurulumunu Tekrar Ateşleme

Şimdi yarım kalan hikayemizi tamamlayalım. Aynı klasör içerisinden Istio kurulum komutunu tekrar gönder:
```Bash
istioctl install --set profile=demo -y
```


#### 📦 1. Aşama: Test Uygulamalarını ve Namespace'i Hazırlama

Istio kurulum bittiği an (veya paralel bir terminal sekmesinde), Envoy proxy'lerin podların yanına otomatik olarak enjekte edilebilmesi için prod-apps alanını hazırlayalım:
```Bash

# 1. Testlerimizin koşacağı izole alanı açalım
kubectl create namespace prod-apps

# 2. Istio Auto-Injection etiketini bu namespace'e basalım
kubectl label namespace prod-apps istio-injection=enabled

# 3. Mimaride konuşulan rolleri simüle edecek podları ayağa kaldıralım
# order-service (İzinli yasal servisimiz)
kubectl run order-service -n prod-apps --image=curlimages/curl --labels="app=order-service" --command -- sleep 365d

# hacker-service (Ağa sızmış yetkisiz pod simülasyonu)
kubectl run hacker-service -n prod-apps --image=curlimages/curl --labels="app=hacker-service" --command -- sleep 365d

# payment-service (Kritik ödeme katmanı)
kubectl run payment-service -n prod-apps --image=hashicorp/http-echo --labels="app=payment-service" -- -text="[SUCCESS] Odeme Alindi - Aegis Mesh Kalkanı Aktif!"

# 4. Ödeme servisini küme içinde erişilebilir kılmak için expose edelim
kubectl expose pod payment-service -n prod-apps --port=80 --target-port=5678
```

#### 🔐 2. Aşama: Yazdığımız Kalkan Politikalarını Uygulama

Şimdi repomuzda (Aegis_Service_Mesh) tasarladığımız kurumsal Zero-Trust kurallarını aktif etme zamanı. İlgili dizine geçip manifestoları gönderelim:
```Bash

cd ~/Repos/DevOpsProjects/Kubernetes/Aegis_Service_Mesh

# 1. mTLS STRICT (Şifresiz geçiş yok) politikasını uygula
kubectl apply -f istio_security/peer-authentication.yaml

# 2. Sadece order-service'e izin veren RBAC politikasını devreye al
kubectl apply -f istio_security/istio-auth-policy.yaml
```


#### 🧪 3. Aşama: Lab Ortamında Canlı Güvenlik Testi (Chaos & Penetration)

Politikalar oturduktan sonra ağın sızdırmazlığını ve yetkilendirmeyi test edelim.
🟢 Senaryo A: Meşru Trafik Kontrolü

order-service podundan payment-service'e gidelim. Bu isteğin sorunsuz geçmesi gerekiyor:
```Bash

kubectl exec -n prod-apps -it order-service -- curl -X POST http://payment-service/v1/charge
# Beklenen çıktı: [SUCCESS] Odeme Alindi - Aegis Mesh Kalkanı Aktif!
```

#### 🔴 Senaryo B: Yetkisiz Erişim (Hacker/Sızma) Simülasyonu

Şimdi ağdaki herhangi bir podun (hacker-service) aynı adrese sızmaya çalıştığında nasıl duvara tosladığını görelim:
```Bash

kubectl exec -n prod-apps -it hacker-service -- curl -X POST http://payment-service/v1/charge
# Beklenen çıktı: RBAC: access denied (HTTP 403)

```