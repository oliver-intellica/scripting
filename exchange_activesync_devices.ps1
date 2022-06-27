# get a liswt of acgivesync devuces linked to the target usermailboxid
Get-ActiveSyncDevice -Mailbox usermailboxid | Select-Object FriendlyName,FirstSyncTime,Guid

# Grab the GUID and remove the activesync partnership you want to clean up.
Remove-ActiveSyncDevice -Identity xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
