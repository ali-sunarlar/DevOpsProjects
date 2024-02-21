Start-Process Powershell.exe -Verb runAs
Import-Module servermanager
Add-WindowsFeature web-mgmt-service
install-WindowsFeature Web-Asp-Net45
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1
Start-Service wmsvc
net user iisadmin "Password" /add
net localgroup "Administrators" "iisadmin" /add 