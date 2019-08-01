#Create FSLogix Directory
New-Item -ItemType "Directory" -Path "C:\FSLogix"

#Download and move AzCopy
Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing

#Expand Archive
Expand-Archive ./AzCopy.zip ./AzCopy -Force

#Move AzCopy to the destination you want to store it
Get-ChildItem "./AzCopy/*/azcopy.exe" | Move-Item -Destination "C:\FSLogix\AzCopy.exe"

# Copy FSLogix files from Azure storage to local directory
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2084562" -OutFile FSLogix.zip -UseBasicParsing

#Expand Archive
Expand-Archive ./FSLogix.zip ./FSLogix -Force

#Move FSLogix to the destination you want to store it
Get-ChildItem "./FSLogix/x64/Release/FSLogixAppsSetup.exe" | Move-Item -Destination "C:\FSLogix\FSLogixAppsSetup.exe"

#change directory to FSLogix
Set-Location C:\FSLogix

# Execute the setup file
$arguments = "/quiet /norestart /ProductKey=MSFT0-YXKIX-NVQI4-I6WIA-O4TXE"
$filepath = "c:\FSLogix\FSLogixAppsSetup.exe"
Start-Process $filepath $arguments -wait

#Create FSLogix keys
New-Item -Path "HKLM:\Software\FSLogix\" -Name "Profiles"
New-ItemProperty -Path "HKLM:\Software\FSLogix\Profiles" -Name "Enabled" -PropertyType "Dword" -Value 1
New-ItemProperty -Path "HKLM:\Software\FSLogix\Profiles" -Name "VHDLocations" -PropertyType MultiString -Value "Network path"