net user serveradmin "Password" /add

net localgroup "Administrators" "serveradmin" /add

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -Type DWord -Value 1

Start-service WinRM

Set-Item WSMan:\localhost\Client\TrustedHosts "172.30.93.118" -Concatenate -Force