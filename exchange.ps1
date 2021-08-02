# Cleans out moved/deleted mailboxes in database QFSDB2
Get-MailboxStatistics -Database "QFSDB2" -OutBuffer 1000 | ? {$_.DisconnectReason -eq "SoftDeleted"} | foreach {Remove-StoreMailbox -Database $_.database -Identity $_.mailboxguid -MailboxState SoftDeleted -Confirm}

# Cleans out moved/deleted mailboxes in database Mailbox Database 2013011115
Get-MailboxStatistics -Database "Mailbox Database 2013011115" -OutBuffer 1000 | ? {$_.DisconnectReason -eq "SoftDeleted"} | foreach {Remove-StoreMailbox -Database $_.database -Identity $_.mailboxguid -MailboxState SoftDeleted -Confirm}

# Show move requests progress
Get-MoveRequest -ResultSize Unlimited | Get-MoveRequestStatistics

# Show the available whitespace on the databases
Get-MailboxDatabase -Status | select Name,DatabaseSize,AvailableNewMailboxSpace

# Get Mailbox statistics
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descendi
ng | Select-Object DisplayName,TotalItemSize,Database

# Get Mailbox statistics and export to a csv file
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descendi
ng | Select-Object DisplayName,TotalItemSize,Database | Export-Csv c:\mailboxstats.csv


#Add mailbox permissions for Calendar access with group selection and object iteration loop
$mailboxes = @(Get-ADGroupMember "Executive" | ForEach-Object { get-mailbox $_.distinguishedname })
foreach ($mbx in $mailboxes) { Add-MailboxFolderPermission -Identity "$($mbx.Alias):\Calendar" -User omorgan -AccessRights Reviewer}

# Get a list of all the mailboxes that forward to a particular user (johndoe).
$RecipientCN = (get-recipient johndoe).Identity
Get-Mailbox -ResultSize Unlimited -Filter "ForwardingAddress -eq '$RecipientCN'"
