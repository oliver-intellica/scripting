# This script update the internal URLs of the virtual directories in Exchange/IIS
# particulary useful when migrating services to Exchange 2016/2019 from a previous version

$ServerName = "SERVER01"
$FQDN = "mail.yourodmain.com"

Get-OWAVirtualDirectory -Server $ServerName | Set-OWAVirtualDirectory -InternalURL https://$($FQDN)/owa -ExternalURL “https://$($FQDN)/owa”

Get-ECPVirtualDirectory -Server $ServerName | Set-ECPVirtualDirectory -InternalURL “https://$($FQDN)/ecp” -ExternalURL “https://$($FQDN)/ecp”

Get-OABVirtualDirectory -Server $ServerName | Set-OABVirtualDirectory -InternalURL “https://$($FQDN)/oab” -ExternalURL “https://$($FQDN)/oab”

Get-ActiveSyncVirtualDirectory -Server $ServerName | Set-ActiveSyncVirtualDirectory -InternalURL https://$($FQDN)/Microsoft-Server-ActiveSync -ExternalURL “https://$($FQDN)/Microsoft-Server-ActiveSync”

Get-WebServicesVirtualDirectory -Server $ServerName | Set-WebServicesVirtualDirectory -InternalURL “https://$($FQDN)/EWS/Exchange.asmx” -ExternalURL https://$($FQDN)/EWS/Exchange.asmx -BasicAuthentication $true

Get-MapiVirtualDirectory -Server $ServerName | Set-MapiVirtualDirectory -InternalURL “https://$($FQDN)/mapi” -ExternalURL “https://$($FQDN)/mapi”

Get-OutlookAnywhere -Server $ServerName | Set-OutlookAnywhere -ExternalHostname $FQDN -InternalHostname $FQDN -ExternalClientsRequireSsl $true -InternalClientsRequireSsl $true -DefaultAuthenticationMethod NTLM
