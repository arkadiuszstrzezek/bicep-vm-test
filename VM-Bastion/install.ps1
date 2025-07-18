Install-WindowsFeature -name Web-Server -IncludeManagementTools

Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/29b3b664-3a47-4a5c-9b92-1c0eee3bd908/7b4261786f4ec3bed982f2ed18e3e1c4/dotnet-hosting-6.0.28-win.exe" -OutFile "dotnet-hosting.exe"
Start-Process -FilePath ".\dotnet-hosting.exe" -ArgumentList "/quiet" -Wait
Remove-Item ".\dotnet-hosting.exe"