$password = Read-Host "Enter password" -AsSecureString

New-Mailbox -UserPrincipalName username@example.com -Alias anash -Database "DBNAME" -Name "FirstName LastName" -OrganizationalUnit "the OU" -Password $password -DisplayName "FirstName LastName" -ResetPasswordOnNextLogon $false

Add-ADGroupMember CloudSignatures username

## Then go migrate mailbox using the 365 portal GUI (or exchange online powershell)

# $Credentials = Get-Credential
# $MigrationEndpointOnPrem = New-MigrationEndpoint -ExchangeRemoteMove -Name OnpremEndpoint -Autodiscover -EmailAddress administrator@onprem.contoso.com -Credentials $Credentials
$OnboardingBatch = New-MigrationBatch -Name RemoteOnBoarding1 -SourceEndpoint $MigrationEndpointOnprem.Identity -TargetDeliveryDomain contoso.mail.onmicrosoft.com -CSVData ([System.IO.File]::ReadAllBytes("C:\Users\Administrator\Desktop\RemoteOnBoarding1.csv"))
Start-MigrationBatch -Identity $OnboardingBatch.Identity

### After Migration of mailbox

# Set ACLs on mailboxes in Exchange Online - resoles some cross permissions issues between Exchange 2010 and EXO in a hybrid configuration
Get-RemoteMailbox -ResultSize unlimited | where {$_.RecipientTypeDetails -eq "RemoteUserMailbox"} | foreach {Get-AdUser -Identity $_.Guid | Set-ADObject -Replace @{msExchRecipientDisplayType=-1073741818}}

# Manual setting of delegation permissions - run these on EXO and On-Prem.
# On-Prem
Add-ADPermission -Identity EXO1 -User ONPREM1 -AccessRights ExtendedRight -ExtendedRights "Send As"
# Exchange Online
Add-RecipientPermission -Identity EXO1 -Trustee ONPREM1 -AccessRights SendAs


### Then sync data in Exclimaer cloud and do a policy test for the new users
