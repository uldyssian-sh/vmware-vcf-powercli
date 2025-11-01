# Installation Guide

## Prerequisites

### System Requirements
- PowerShell 7.2 or later
- Windows 10/11, Windows Server 2019/2022, or Linux/macOS
- Network access to VCF SDDC Manager (HTTPS 443)

### PowerCLI Installation
```powershell
# Install VMware PowerCLI
Install-Module -Name VMware.PowerCLI -MinimumVersion 13.3.0 -Scope CurrentUser

# Install VCF PowerCLI
Install-Module -Name VCF.PowerCLI -RequiredVersion 9.0.0.24798382 -Scope CurrentUser
```

### Configuration
```powershell
# Configure PowerCLI settings
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
```

## Verification
```powershell
# Verify installation
Get-Module -Name VMware.PowerCLI, VCF.PowerCLI -ListAvailable
```