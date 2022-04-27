$password = Read-Host "Enter password" -AsSecureString

New-Mailbox -UserPrincipalName username@example.com -Alias anash -Database "DBNAME" -Name "FirstName LastName" -OrganizationalUnit "the OU" -Password $password -DisplayName "FirstName LastName" -ResetPasswordOnNextLogon $false

# Add to relevent group memberships
Add-ADGroupMember CloudSignatures username
#use this one liner to copy another users group memberships wholesale
Get-ADUser -Identity existinguser01 -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members newuser01

# then sync
repadmin /syncall /APeD

# then adsync
start-AdsyncSyncCycle -PolicyType Delta

## Then go migrate mailbox using the 365 portal GUI (or exchange online powershell)

# $Credentials = Get-Credential
# $MigrationEndpointOnPrem = New-MigrationEndpoint -ExchangeRemoteMove -Name OnpremEndpoint -Autodiscover -EmailAddress administrator@onprem.contoso.com -Credentials $Credentials
# if you already have a migraiton endpoint you can just go 
$migrationEndpointOnPrem = get-migrationendpoint # instead of creating a new one.

#Creation the batch and autostart and autocomplete it
$OnboardingBatch = New-MigrationBatch -Name RemoteOnBoarding1 -SourceEndpoint $MigrationEndpointOnprem.Identity -TargetDeliveryDomain contoso.mail.onmicrosoft.com -CSVData ([System.IO.File]::ReadAllBytes("C:\Users\Administrator\Desktop\RemoteOnBoarding1.csv"))  -AutoComplete -AutoStart -NotificationEmails user@user.com
Start-MigrationBatch -Identity $OnboardingBatch.Identity # only needed if autstart not specified in New-MigraitonBatch

## Note the -CSVDATA file should be in the format:
## EMAILADDRESS
## user1@example.com
## user2@example.com 
## ...
## usern@@example.com

Get-MigrationBatch # to monitor progress if you want to

### After Migration of mailbox

### Assigning Licensing
Connect-MSOL
Get-MsolAccountSku
Set-MsolUser -UserPrincipalName user@example.com -UsageLocation AU
Set-MsolUserLicense -UserPrincipalName user@example.com -AddLicenses organisationame:SPB # SPD is Microsoft 365 Business Premium


# Set ACLs on mailboxes in Exchange Online - resolves some cross permissions issues between Exchange 2010 and EXO in a hybrid configuration
Get-RemoteMailbox -ResultSize unlimited | where {$_.RecipientTypeDetails -eq "RemoteUserMailbox"} | foreach {Get-AdUser -Identity $_.Guid | Set-ADObject -Replace @{msExchRecipientDisplayType=-1073741818}}

# Manual setting of delegation permissions - run these on EXO and On-Prem.
# On-Prem
Add-ADPermission -Identity EXO1 -User ONPREM1 -AccessRights ExtendedRight -ExtendedRights "Send As"
# Exchange Online
Add-RecipientPermission -Identity EXO1 -Trustee ONPREM1 -AccessRights SendAs


### Then sync data in Exclimaer cloud and do a policy test for the new users
