# Author Credit: Thomas Maurer https://www.thomasmaurer.ch/

### Creating install media for server 2022 with a USB drive GPT/UEFI style. ###

# Define Path to the Windows Server 2022 ISO
$ISOFile = "C:\Temp\WindowsServer2022.iso"

# Create temp diectroy for new image
$newImageDir = New-Item -Path 'C:\Temp\newimage' -ItemType Directory

# Mount iso
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru

# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter

# Copy Files to temporary new image folder 
Copy-Item -Path ($ISODriveLetter +":\*") -Destination C:\Temp\newimage -Recurse

# Split and copy install.wim (because of the filesize)
dism /Split-Image /ImageFile:C:\Temp\newimage\sources\install.wim /SWMFile:C:\Temp\newimage\sources\install.swm /FileSize:4096

 
# Get the USB Drive you want to use, copy the disk number
Get-Disk | Where BusType -eq "USB"
 
# Get the right USB Drive (You will need to change the number)
$USBDrive = Get-Disk | Where Number -eq 2
 
# Replace the Friendly Name to clean the USB Drive (THIS WILL REMOVE EVERYTHING)
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru
 
# Convert Disk to GPT
$USBDrive | Set-Disk -PartitionStyle GPT
 
# Create partition primary and format to FAT32
$Volume = $USBDrive | New-Partition -Size 8GB -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel WS2022
 
# Copy Files to USB (Ignore install.wim)
Copy-Item -Path C:\Temp\newimage\* -Destination ($Volume.DriveLetter + ":\") -Recurse -Exclude install.wim

# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile

### END ###

### Creating install media for server 2022 with a USB drive MRB/Legacy style. ###

# Define Path to the Windows Server 2022 ISO
$ISOFile = "C:\Temp\WindowsServer2022.iso"
 
# Get the USB Drive you want to use, copy the friendly name
Get-Disk | Where BusType -eq "USB"
 
# Get the right USB Drive (You will need to change the FriendlyName)
$USBDrive = Get-Disk | Where FriendlyName -eq "Kingston DT Workspace"
 
# Replace the Friendly Name to clean the USB Drive (THIS WILL REMOVE EVERYTHING)
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru
 
# Convert Disk to MBR
$USBDrive | Set-Disk -PartitionStyle MBR
 
# Create partition primary and format to NTFS
$Volume = $USBDrive | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -NewFileSystemLabel WS2022
 
# Set Partiton to Active
$Volume | Get-Partition | Set-Partition -IsActive $true
 
# Mount ISO
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru
 
# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter
 
# Copy Files to USB
Copy-Item -Path ($ISODriveLetter +":\*") -Destination ($Volume.DriveLetter + ":\") -Recurse
 
# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile

### END ###
