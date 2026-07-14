<#
.SYNOPSIS
    FinOps Control - Etiketsiz Kaynak Tespit ve Raporlama Betigi
.DESCRIPTION
    Abonelikteki tum kaynak gruplarini tarar, kritik etiketleri eksik olanlari listeler.
#>
Import-Module Az.Resources -ErrorAction SilentlyContinue

Write-Output "[*] Etiketsiz kaynak denetimi baslatiliyor..."
$RequiredTags = @("Environment", "Owner", "CostCenter")
$AllResources = Get-AzResource

$UntaggedCount = 0

foreach ($Resource in $AllResources) {
    $MissingTags = @()
    foreach ($Tag in $RequiredTags) {
        if (-not $Resource.Tags.ContainsKey($Tag)) {
            $MissingTags += $Tag
        }
    }
    
    if ($MissingTags.Count -gt 0) {
        Write-Warning "[ALERT] Sahipsiz Kaynak Yakalandi: $($Resource.Name) [Tip: $($Resource.ResourceType)] - Eksik Etiketler: $($MissingTags -join ', ')"
        $UntaggedCount++
        
        # Opsiyonel Kurumsal Aksiyon: Buraya otomatik 'Status=ReviewRequired' etiketi basilabilir.
    }
}

Write-Output "[SUCCESS] Denetim bitti. Toplam sahipsiz kaynak sayisi: $UntaggedCount"
