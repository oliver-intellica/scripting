# Exhcnage Online: approves migration mailboxes stuck on investigate faster thant the GUI. Review the mailbox first before using!
Get-MigrationUser -BatchID "Batch" | where dataconsistencyscore -eq Investigate | where status -eq Synced | Set-MigrationUser -ApproveSkippedItems

# Exchange 2010 CSR example
New-ExchangeCertificate -GenerateRequest -KeySize 4096 -SubjectName "c=AU, l=Brisbane, s=QLD, o=YourCompanyInc, cn=YourFirstDomain.com" -DomainName YourSecondDomain.com, YourThirdDomain.com -PrivateKeyExportable:$true

# Cleans out moved/deleted mailboxes in database QFSDB2
# Note: replace "SofteDeleted" with "Disabled" for mailboxes that have not yet been deleted but you want to clear out as well.
Get-MailboxStatistics -Database "QFSDB2" -OutBuffer 1000 | ? {$_.DisconnectReason -eq "SoftDeleted"} | foreach {Remove-StoreMailbox -Database $_.database -Identity $_.mailboxguid -MailboxState SoftDeleted -Confirm}

# Show move requests progress
Get-MoveRequest -ResultSize Unlimited | Get-MoveRequestStatistics

# Show the available whitespace on the databases
Get-MailboxDatabase -Status | select Name,DatabaseSize,AvailableNewMailboxSpace

# Get Mailbox statistics
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descending | Select-Object DisplayName,TotalItemSize,Database

# Get Mailbox statistics and export to a csv file
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descending | Select-Object DisplayName,TotalItemSize,Database | Export-Csv c:\mailboxstats.csv

#Add mailbox permissions for Calendar access with group selection and object iteration loop
$mailboxes = @(Get-ADGroupMember "Executive" | ForEach-Object { get-mailbox $_.distinguishedname }) foreach ($mbx in $mailboxes) { Add-MailboxFolderPermission -Identity "$($mbx.Alias):\Calendar" -User omorgan -AccessRights Reviewer}

# Get a list of all the mailboxes that forward to a particular user (johndoe).
$RecipientCN = (get-recipient johndoe).Identity
Get-Mailbox -ResultSize Unlimited -Filter "ForwardingAddress -eq '$RecipientCN'"

# Message tracing with export in Exchange 2010 shell example
get-messagetrackinglog -Start "6/11/2021 12:00:00 AM" -End "7/11/2021 11:59:59 PM" | select timestemp, eventid, source, sourcetext, messageid, messagesubject, sender, {$recipients}, internalmessageid, clientip, clienthostname, serverip, serverhostname, connectorid, {$_.recipientstatus}, totalbytes, recipiencount, relatedrecipientaddress, reference, returnpath, messageinfo | export-csv c:\exportfile.csv

# Mailbox Recipient Permissions with hybrid exchange run in exchange online
Add-RecipientPermission -Identity EXO1USER -Trustee ONPREM1USER -AccessRights SendAs
