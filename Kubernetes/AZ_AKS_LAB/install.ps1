Write-Host "1. Aktif Resource Group adı otomatik tespit ediliyor..." -ForegroundColor Cyan
$RG_NAME = az group list --query "[].name" -o tsv

if (-not $RG_NAME) {
    Write-Error "Resource Group bulunamadı! Azure oturumunuzu kontrol edin."
    exit
}
Write-Host "Bulunan Resource Group: $RG_NAME" -ForegroundColor Green

Write-Host "2. AKS Kümesi kontrol ediliyor..." -ForegroundColor Cyan
$CLUSTER_EXISTS = az aks list --resource-group $RG_NAME --query "[?name=='muhasebe-aks-cluster'].name" -o tsv

if (-not $CLUSTER_EXISTS) {
    Write-Host "Küme bulunamadı. Sıfırdan AKS kümesi oluşturuluyor (Bu işlem 4-5 dk sürebilir)..." -ForegroundColor Yellow
    az aks create `
      --resource-group $RG_NAME `
      --name muhasebe-aks-cluster `
      --node-count 1 `
      --node-vm-size Standard_B2s `
      --generate-ssh-keys `
      --node-osdisk-size 30
} else {
    Write-Host "AKS Kümesi zaten mevcut, oluşturma adımı atlanıyor." -ForegroundColor Green
}

Write-Host "3. Küme erişim anahtarları (Credentials) otomatik çekiliyor..." -ForegroundColor Cyan
az aks get-credentials --resource-group $RG_NAME --name muhasebe-aks-cluster --overwrite-existing

Write-Host "4. Kurumsal Altyapı YAML dosyası Kubernetes'e uygulanıyor..." -ForegroundColor Cyan
kubectl apply -f kurumsal-altyapi.yaml

Write-Host "TEBRİKLER! Tüm altyapı sıfırdan otomatik olarak kuruldu." -ForegroundColor Green