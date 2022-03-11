# Check your cloud shell public IP
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

# Workaround for the certificate failure bug when trying to remote to VMs
Install-Module pswsman
Disable-WSManCertVerification -All

# Create and enter session on a VM
 Enter-AzVM -Name "VM Name" -ResourceGroupName "resource group name" -Credential (Get-Credential)
 
 
