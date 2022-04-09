FROM mcr.microsoft.com/windows/servercore/iis
RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*
WORKDIR /inetpub/wwwroot
SHELL ["powershell"]
RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \
    Install-WindowsFeature Web-Asp-Net45
COPY GuidGenerator GuidGenerator
COPY content/ .
RUN Remove-WebSite -Name 'Default Web Site'
RUN New-Website -Name 'guidgenerator' -Port 80 \
    -PhysicalPath 'c:\GuidGenerator' -ApplicationPool '.NET v4.5'
EXPOSE 80

CMD ["ping", "-t", "localhost"]
EXPOSE 80