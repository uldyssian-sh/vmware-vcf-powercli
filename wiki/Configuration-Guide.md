# Configuration Guide

## PowerCLI Configuration
```powershell
# Set PowerCLI configuration
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false
```

## Credential Storage
```powershell
# Store credentials securely
$credential = Get-Credential
$credential | Export-Clixml -Path "$env:USERPROFILE\Documents\vcf-credentials.xml"

# Load credentials
$credential = Import-Clixml -Path "$env:USERPROFILE\Documents\vcf-credentials.xml"
```

## Environment Variables
```powershell
$env:VCF_SERVER = "vcf-mgmt01.domain.local"
$env:VCF_USERNAME = "administrator@vsphere.local"
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
