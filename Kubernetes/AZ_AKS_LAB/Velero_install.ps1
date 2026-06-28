#it will be tested

#Adım 1: Helm Deposuna Velero'yu Ekleyelim

helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update

#Adım 2: Yedeklerin Duracağı Bir Storage Account ve Container Oluşturalım
$BLOB_ACCOUNT = "muhasebevedek" + (Get-Random -Minimum 1000 -Maximum 9999)

# Depolama hesabını oluşturalım
az storage account create --resource-group $RG_NAME --name $BLOB_ACCOUNT --sku Standard_LRS --encryption-services blob

# İçine "velero-backups" adında bir klasör/container açalım
az storage container create --name velero-backups --account-name $BLOB_ACCOUNT

#Azure Blob Storage Bağlantı Anahtarını (Connection String) Kap
$AZURE_STORAGE_KEY = az storage account keys list --account-name $BLOB_ACCOUNT --resource-group $RG_NAME --query "[0].value" -o tsv



helm install velero vmware-tanzu/velero `
  --namespace velero `
  --create-namespace `
  --set provider=azure `
  --set configuration.backupStorageLocation[0].name=default `
  --set configuration.backupStorageLocation[0].provider=azure `
  --set configuration.backupStorageLocation[0].bucket=velero-backups `
  --set configuration.backupStorageLocation[0].config.resourceGroup=$RG_NAME `
  --set configuration.backupStorageLocation[0].config.storageAccount=$BLOB_ACCOUNT `
  --set configuration.backupStorageLocation[0].config.storageAccountKeyEnvVar=AZURE_STORAGE_KEY `
  --set env[0].name=AZURE_STORAGE_KEY `
  --set env[0].value=$AZURE_STORAGE_KEY `
  --set configuration.volumeSnapshotLocation=null


  #durum kontrolü
  kubectl get pods -n velero

  #ilk yedek
  kubectl apply -f ilk-yedek.yaml

  #yedekleme durum kontrolü
  kubectl get backups -n velero

  #Felaket Senaryosu (Her Şeyi Canlı Canlı Sil!)
  kubectl delete -f ./kurumsal-altyapi.yaml