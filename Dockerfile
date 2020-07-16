FROM mcr.microsoft.com/windows/servercore:1809 as core
FROM mcr.microsoft.com/powershell:preview-nanoserver-1809
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll

ENV CURL_VERSION 7.71.1

RUN pwsh.exe -Command \
    $ErrorActionPreference = 'Stop' ; \
    Invoke-WebRequest -Method Get -Uri https://curl.haxx.se/windows/dl-7.71.1/curl-7.71.1-win64-mingw.zip -OutFile 'C:\Program Files\curl.zip' ; \
    Expand-Archive -Path 'C:\Program Files\curl.zip' -DestinationPath 'C:\Program Files' ; \
    Remove-Item 'C:\Program Files\curl.zip' -Force

COPY ["entrypoint.ps1", "C:/Program Files/curl-7.71.1-win64-mingw/bin"]

WORKDIR "C:\Program Files\curl-7.71.1-win64-mingw\bin"

CMD ["pwsh.exe", "entrypoint.ps1"']
