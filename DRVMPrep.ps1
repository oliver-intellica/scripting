#Install the Hyper-V role and managmeent tools
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

# Set our time/zone info
Set-TimeZone "E. Australia Standard Time"
Set-WinSystemLocale -SystemLocal en-AU

#Download our recovery console installer
$url = "http://cdn.cloudbackup.management/maxdownloads/mxb-rc-windows-x64.exe"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -uri $url -OutFile rc.exe
$ProgressPreference = "Continue"

# initialize and format our virtual disk to hold the virtual disaster recover install files
get-disk | Where-Object PartitionStyle -eq 'raw' | sort number | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -UseMaximumSize -DriveLetter F | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Restore Data" -Confirm

#Restart the computer as it needs a reboot before installing the recovery console - check on this each time you use it as you may not have to depending on what updates/state the latest azure image is
Restart-Computer

#After reboot, then install the recovery console and add the backup device
#.\rc.exe
