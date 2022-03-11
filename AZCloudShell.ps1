# Make sure you are  in the right subscription/context or thing just won't work!
az account list # lists your subscriptions
az account set # will set your default subsctiption when you logon
Get-AzContext # get the current context you are working in
Set-AzContext "sub id" # set the context you want to be working in!

# Enable Remoting to your AZ VM - this opens up winRM publicly in the NSG as well - so be careful and lock it down to your IP and/or your cloud shell Public IP
Enable-AzVMPSRemoting -Name "VM Name" -ResourceGroupName "resource group name"

# Check your cloud shell public IP
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

# Update a NSG rule to lock down remote access

# Workaround for the certificate failure bug when trying to remote to VMs
Install-Module pswsman
Disable-WSManCertVerification -All

# Create and enter session on a VM
Enter-AzVM -Name "VM Name" -ResourceGroupName "resource group name" -Credential (Get-Credential)
 
 
