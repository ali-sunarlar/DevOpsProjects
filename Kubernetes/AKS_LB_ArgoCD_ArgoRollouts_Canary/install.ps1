Write-Host "1. Aktif Resource Group adi otomatik tespit ediliyor..." -ForegroundColor Cyan
$RG_NAME = az group list --query "[0].name" -o tsv
Write-Host "Bulunan Resource Group: $RG_NAME" -ForegroundColor Green

Write-Host "2. Sifirdan AKS Kümesi oluşturuluyor (Bu işlem 3-4 dk sürebilir)..." -ForegroundColor Cyan
az aks create --resource-group $RG_NAME --name muhasebe-aks-cluster --node-count 1 --node-vm-size Standard_B2s --generate-ssh-keys -o json

Write-Host "3. Küme erişim anahtarlari (Credentials) otomatik çekiliyor..." -ForegroundColor Cyan
az aks get-credentials --resource-group $RG_NAME --name muhasebe-aks-cluster --overwrite-existing

Write-Host "4. ArgoCD Altyapisi kuruluyor..." -ForegroundColor Cyan
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Write-Host "5. ArgoCD için Azure LoadBalancer (Diş Kapi) açiliyor..." -ForegroundColor Cyan
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

Write-Host "6. 19. Gün: Argo Rollouts (Canary Trafik Motoru) enjekte ediliyor..." -ForegroundColor Cyan
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

Write-Host "7. Sistem hazir! ArgoCD'nin admin şifresi çözülüyor..." -ForegroundColor Cyan
Start-Sleep -Seconds 10
$ADMIN_PASS = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
$DECODED_PASS = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($ADMIN_PASS))

Write-Host "--------------------------------------------------------" -ForegroundColor Yellow
Write-Host "TEBRİKLER ALİ! TÜM ALTYAPI SIFIRDAN KURULDU." -ForegroundColor Green
Write-Host "ArgoCD Kullanici Adi: admin" -ForegroundColor White
Write-Host "ArgoCD Giriş Şifren : $DECODED_PASS" -ForegroundColor White
Write-Host "Azure LoadBalancer IP'sini görmek için birazdan 'kubectl get svc argocd-server -n argocd' koşturabilirsin." -ForegroundColor Yellow
Write-Host "--------------------------------------------------------" -ForegroundColor Yellow