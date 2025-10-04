# The purpose of this script it to enroll devices in MDM (intune) if they have previously been Azure AD Joined (Entra ID Joine) previously but did not
# get enrolled because they were not in scope of auto-enrolment at the time of joining.

# Run as Administrator

# Start Logging Output from the Script
Start-Transcript -Path "C:\IntuneEnrollmentLog.txt" -Append

# Get the TenantInfo key
$key = 'SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\*'
$keyinfo = Get-Item "HKLM:\$key"
$url = $keyinfo.Name.Split("\")[-1]
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$url"

# Set required MDM enrollment URLs
New-ItemProperty -LiteralPath $path -Name 'MdmEnrollmentUrl' -Value 'https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath $path -Name 'MdmTermsOfUseUrl' -Value 'https://portal.manage.microsoft.com/TermsofUse.aspx' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath $path -Name 'MdmComplianceUrl' -Value 'https://portal.manage.microsoft.com/?portalAction=Compliance' -PropertyType String -Force -ErrorAction SilentlyContinue

# Trigger the enrollment
Start-Process "C:\Windows\system32\deviceenroller.exe" -ArgumentList "/c /AutoEnrollMDM"

# Stop logging
Stop-Transcript
