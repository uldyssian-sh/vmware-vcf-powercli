# Quick Start Tutorial

## Prerequisites
- PowerShell 7.2+
- VMware PowerCLI 13.3.0+
- VCF.PowerCLI 9.0.0.24798382+

## Step 1: Installation
```powershell
Install-Module -Name VMware.PowerCLI -MinimumVersion 13.3.0 -Scope CurrentUser
Install-Module -Name VCF.PowerCLI -RequiredVersion 9.0.0.24798382 -Scope CurrentUser
```

## Step 2: Connect to VCF
```powershell
$credential = Get-Credential
Connect-VCFManager -fqdn "vcf-mgmt01.domain.local" -credential $credential
```

## Step 3: Basic Operations
```powershell
# Get workload domains
Get-VCFWorkloadDomain

# Get system health
Get-VCFSystemHealth

# Get hosts
Get-VCFHost
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692691
