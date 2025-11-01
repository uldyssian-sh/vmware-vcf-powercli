# VMware VCF PowerCLI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/VMware.PowerCLI.svg)](https://www.powershellgallery.com/packages/VMware.PowerCLI)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=vmware-vcf-powercli&metric=security_rating)](https://sonarcloud.io/dashboard?id=vmware-vcf-powercli)

Enterprise-grade PowerShell scripts and modules for VMware Cloud Foundation (VCF) management using PowerCLI.

## Table of Contents

- [Overview](#overview)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository provides production-ready PowerShell scripts for managing VMware Cloud Foundation environments. All scripts follow enterprise security standards and best practices.

## System Requirements

### Supported Operating Systems
- Windows Server 2019 (Build 17763) or later
- Windows Server 2022 (Build 20348) or later
- Windows 10 (Build 1809) or later
- Windows 11 (Build 22000) or later

### PowerShell Requirements
- PowerShell 5.1 (Windows PowerShell)
- PowerShell 7.0 or later (PowerShell Core)

### VMware PowerCLI Compatibility
- VMware PowerCLI 13.0 or later
- VMware Cloud Foundation 4.5 or later
- VMware Cloud Foundation 5.0 or later

## Installation

### Prerequisites

1. **Enable PowerShell Execution Policy**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Install NuGet Provider** (if not present)
   ```powershell
   Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
   ```

3. **Trust PowerShell Gallery**
   ```powershell
   Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
   ```

### VMware PowerCLI Installation

#### Method 1: PowerShell Gallery (Recommended)
```powershell
# Install latest version
Install-Module -Name VMware.PowerCLI -Scope CurrentUser

# Verify installation
Get-Module -Name VMware.PowerCLI -ListAvailable
```

#### Method 2: Offline Installation
```powershell
# Download from PowerShell Gallery
Save-Module -Name VMware.PowerCLI -Path "C:\Temp\PowerCLI"

# Install from downloaded files
Install-Module -Name VMware.PowerCLI -Repository PSGallery -Force
```

### Post-Installation Configuration

```powershell
# Set PowerCLI configuration
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false
```

## Configuration

### Environment Variables
Create a `.env` file (not tracked in git):
```
VCF_SDDC_MANAGER=vcf-mgmt01.domain.local
VCF_USERNAME=administrator@vsphere.local
VCF_DOMAIN=domain.local
```

### Credential Management
```powershell
# Store credentials securely
$credential = Get-Credential
$credential | Export-Clixml -Path "$env:USERPROFILE\vcf-creds.xml"

# Load credentials
$credential = Import-Clixml -Path "$env:USERPROFILE\vcf-creds.xml"
```

## Usage Examples

See the [examples](./examples/) directory for comprehensive usage examples.

## Security

- All scripts follow PowerShell security best practices
- Credentials are never stored in plain text
- Input validation and error handling implemented
- Logging capabilities for audit trails
- No hardcoded sensitive information

### Security Scanning
This repository is scanned with:
- PowerShell Script Analyzer (PSScriptAnalyzer)
- Bandit security linter
- SonarCloud security analysis

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.