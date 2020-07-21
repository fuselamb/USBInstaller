# Define Path to the Windows Server 2019 ISO
$ISOFile = "R:\ISO\Microsoft Software\Windows Server\Windows Server 2019\1909\17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
 
# Get the USB Drive you want to use, copy the friendly name
Get-Disk | Where BusType -eq "USB"
 
# Get the right USB Drive (You will need to change the FriendlyName)
$USBDrive = Get-Disk | Where FriendlyName -eq " Patriot Memory"
 
# Replace the Friendly Name to clean the USB Drive (THIS WILL REMOVE EVERYTHING)
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru
 
# Convert Disk to GPT
$USBDrive | Set-Disk -PartitionStyle GPT
 
# Create partition primary and format to FAT32
$Volume = $USBDrive | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel WS2019
 
# Mount iso
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru
 
# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter
 
# Copy Files to USB 
Copy-Item -Path ($ISODriveLetter +":\*") -Destination ($Volume.DriveLetter + ":\") -Recurse
 
# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile

# Split WIM
dism /Split-Image /ImageFile:k:\sources\install.wim /SWMFile:i:\sources\install.swm /FileSize:4096