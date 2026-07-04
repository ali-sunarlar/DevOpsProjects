# Azure Zero-Trust K8s Sandbox (Project Stealth-Cluster)

Bu laboratuvar projesi, Microsoft Azure üzerinde **Zero-Trust (Sıfır Güven)** ağ mimarisi ilkelerine uygun olarak izole edilmiş bir **Azure Kubernetes Service (AKS)** kümesi ve internet trafiğine tamamen kapatılmış, sadece iç ağdan erişilebilen bir **Azure SQL Database (PaaS)** altyapısını uçtan uca inşa eder.

## 🏗️ Mimari Özet

Proje, kurumsal ortamlarda sıkça karşımıza çıkan "PaaS servislerinin internete açık endpoint barındırmaması" regülasyonunu simüle eder.

- **VNet İzolasyonu:** Tüm altyapı `10.0.0.0/16` adres uzayına sahip bir sanal ağ içerisindedir. AKS Pod'ları ve Veritabanı farklı subnet'lerde segmentlere ayrılmıştır.
- **Private Endpoint (Özel Uç Nokta):** Azure SQL Server'ın public internet erişimi (`public_network_access_enabled = false`) tamamen kapatılmıştır. Bunun yerine veritabanı, veritabanı subnet'inden izole bir yerel IP (`10.0.2.X`) alarak ağın içerisine gömülmüştür.
- **Private DNS Zone Entegrasyonu:** `privatelink.database.windows.net` özel DNS bölgesi oluşturularak VNet'e bağlanmıştır. Bu sayede uygulama kodundaki `holding-prod-sqlserver-99.database.windows.net` adresi, internetteki public IP yerine otomatik olarak iç ağdaki lokal IP'ye çözümlenir.
- **AKS Network Çakışma Önlemi (Fix):** AKS iç servis ağının (`Service CIDR`) dış ağ ve subnet'lerle çakışmasını önlemek amacıyla Kubernetes iç dünyası `172.16.0.0/16` bloklarına taşınmıştır.

## 📁 Proje Dosya Yapısı

```text
Azure_ZeroTrust_K8s_Sandbox/
├── main.tf                 # Tüm Azure altyapısını kuran güncel Terraform kodu
├── kurumsal-altyapi.yaml   # AKS üzerine deploy edilecek güvenli web uygulaması
└── README.md               # Proje dökümantasyonu (Bu dosya)
```

## 🚀 Dağıtım Adımları

### 1. Ön Gereksinimler
- Bilgisayarınızda **Azure CLI** ve **Terraform** yüklü olmalıdır.
- Terminalden Azure oturumu açılmış olmalıdır:
  ```bash
  az login
  ```

### 2. Altyapının Terraform ile Kurulması
`main.tf` dosyasının en üstünde yer alan `data "azurerm_resource_group" "lab_rg"` bloğundaki `name` değerini, Azure portalınızdaki mevcut/size atanan Resource Group adı ile değiştirin.

Ardından sırasıyla şu komutları çalıştırın:
```bash
# Eklentileri indirin ve initialize edin
terraform init

# Altyapıyı otomatik onay ile ayağa kaldırın (Yaklaşık 5-7 dakika sürer)
terraform apply -auto-approve
```

### 3. Kubernetes Uygulamasının Dağıtımı
Terraform işlemi başarıyla tamamlandıktan sonra AKS kümenize bağlanın:
```bash
# Küme erişim anahtarlarını yerel kubeconfig'e çekin
az aks get-credentials --resource-group "SİZİN_RESOURCE_GROUP_ADINIZ" --name muhasebe-aks-cluster --overwrite-existing

# Güvenli arka plan bağlantısına sahip web uygulamasını uygulayın
kubectl apply -f kurumsal-altyapi.yaml
```

## 🔒 Güvenlik Notları
- SQL Server yönetici şifresi laboratuvar ortamı için statik bırakılmıştır. Üretim (Production) ortamlarında bu şifrelerin **Azure Key Vault** üzerinden veya dinamik gizli anahtar yöntemleriyle beslenmesi gerekir.
- Sağlayıcı (Provider) yetki kısıtlamalarını aşmak adına `resource_provider_registrations = "none"` ayarı aktif edilmiştir.