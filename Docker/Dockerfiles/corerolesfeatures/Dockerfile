FROM mcr.microsoft.com/windows/servercore:1607
LABEL Description="Custom-Windows" Vendor="Microsoft" Version="1"
RUN powershell -Command Install-WindowsFeature Web-server, \
    Web-Asp-Net45, Net-Framework-45-ASPNET, \
    DNS, RSAT-DNS-Server -Verbose
CMD ["ping", "-t","localhost">NULL]