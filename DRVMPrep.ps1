Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
Set-TimeZone "E. Australia Standard Time"
Set-WinSystemLocale -SystemLocal en-AU
$url = "http://cdn.cloudbackup.management/maxdownloads/mxb-rc-windows-x64.exe"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -uri $url -OutFile rc.exe
$ProgressPreference = "Continune"
Restart-Computer
