# GPO ile Ağ Üzerinden Windows 11 Yükseltme Altyapısı

Bu dizin, kurumsal ağ içerisindeki Windows 10 istemci bilgisayarların donanım kısıtlamalarına (TPM 2.0 / CPU) takılmaksızın, merkezi bir ağ paylaşımı üzerinden otomatik olarak Windows 11'e yükseltilmesini sağlayan Group Policy mimarisini içerir.

## 🛠️ Active Directory GPO Dağıtım Adımları

1. **Betik Lokasyonu:**
   * `upgrade_trigger.ps1` betiğini Active Directory etki alanı denetleyicinizdeki (Domain Controller) ilgili GPO'nun `Scripts\Startup` klasörüne kopyalayın:
     `\\kurumsal.int\sysvol\kurumsal.int\Policies\{GPO-GUID}\Machine\Scripts\Startup\`

2. **GPO İlkesinin Yapılandırılması:**
   * **Grup İlkesi Yönetim Konsolu (GPMC)** aracılığıyla yeni bir GPO oluşturun: `GPO_Windows11_Upgrade_Baseline`
   * Aşağıdaki yolu takip edin:
     `Computer Configuration` -> `Policies` -> `Windows Settings` -> `Scripts (Startup/Shutdown)` -> `Startup`
   * **PowerShell Scripts** sekmesine tıklayın, `Add` butonuna basarak `upgrade_trigger.ps1` betiğini ekleyin.
   * Betiğin tam olarak tamamlanmasını garanti altına almak için şu ilkeyi aktif edin:
     `Computer Configuration` -> `Policies` -> `Administrative Templates` -> `System` -> `Group Policy` -> **Specify Startup script execution wait time** = `1800` (30 dakika)

3. **Güvenlik ve İzinler:**
   * `\\kurumsal-nas\iso\` paylaşım klasöründe, Active Directory üzerindeki **"Domain Computers"** grubuna en az `Read` (Okuma) izni verildiğinden emin olun. (Betik bilgisayar hesabı bağlamında çalışır).

4. **İzleme ve Raporlama:**
   * İstemci makinelerdeki yükseltme adımları ve olası hatalar yerel olarak `C:\Windows\Logs\Windows11_Upgrade.log` dosyası üzerinden takip edilebilir.
