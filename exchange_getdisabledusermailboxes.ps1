$Mailboxes = Get-Mailbox | where {$_.RecipientTypeDetails -eq 'UserMailbox'}
$Disabled = @()
 
Foreach ($Mailbox in $Mailboxes) {
    if((Get-ADUser -Identity $Mailbox.SamAccountName).Enabled -eq $False){
        $Disabled += Get-MailboxStatistics $Mailbox.SamAccountName | Select -Property DisplayName,TotalItemSize
    }    
}
$Disabled | Export-Csv -Path $env:userprofile\desktop\DisabledADUserwithMailbox.csv -NoTypeInformation
