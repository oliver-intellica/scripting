# Set ACLs on mailboxes in Exchange Online - resoles some cross permissions issues between Exchange 2010 and EXO in a hybrid configuration
Get-RemoteMailbox -ResultSize unlimited | where {$_.RecipientTypeDetails -eq "RemoteUserMailbox"} | foreach {Get-AdUser -Identity $_.Guid | Set-ADObject -Replace @{msExchRecipientDisplayType=-1073741818}}

# Manual setting of delegation permissions - run these on EXO and On-Prem.
# On-Prem
Add-ADPermission -Identity EXO1 -User ONPREM1 -AccessRights ExtendedRight -ExtendedRights "Send As"
# Exchange Online
Add-RecipientPermission -Identity EXO1 -Trustee ONPREM1 -AccessRights SendAs
