# vmware-vcf-powercli




**PowerCLI examples and reference guide for VMware Cloud Foundation (VCF) 9.0 components and related infrastructure management.**

## VCF 9.0 Enterprise Features

- **Enhanced Security** - Certificate lifecycle management, identity federation
- **Simplified Operations** - Automated lifecycle management, health monitoring  
- **Multi-Cloud Ready** - Hybrid cloud connectivity, workload mobility
- **Advanced Networking** - NSX 4.2.0 integration, micro-segmentation
- **Storage Optimization** - vSAN 8.0 U3 performance enhancements

## PowerCLI Examples Included

- **VCF Management** - SDDC Manager connection and basic operations
- **Health Monitoring** - Health check examples and reporting scripts
- **Infrastructure Operations** - Host, cluster, and network management examples
- **Component Connections** - Connection examples for all VCF components
- **Best Practices** - Security and error handling demonstrations

## Table of Contents

- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [Component Guides](#component-guides)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

```powershell
# 1. Install VCF PowerCLI
Install-Module -Name VCF.PowerCLI -Scope CurrentUser

# 2. Clone repository
git clone https://github.com/uldyssian-sh/vmware-vcf-powercli.git
cd vmware-vcf-powercli

# 3. Connect to SDDC Manager
$credential = Get-Credential
.\examples\Connect-VCF.ps1 -Server "vcf-mgmt01.domain.local" -Credential $credential

# 4. Get inventory
.\examples\Get-VCFInventory.ps1
```

## System Requirements

| Component | Requirement |
|-----------|-------------|
| **Operating System** | Windows 10/11, Windows Server 2019/2022, RHEL 8/9, Ubuntu 20.04/22.04, macOS 12+ |
| **PowerShell** | 7.2.0 or later (PowerShell Core) |
| **VCF PowerCLI** | 13.3.0 or later |
| **VCF.PowerCLI** | 9.0.0.24798382 or later |
| **VCF Version** | 9.0.0 (Build 24798382) |
| **vSphere** | 8.0 Update 3 (Build 24022515) |
| **NSX** | 4.2.0 (Build 23761687) |
| **vSAN** | 8.0 Update 3 (Build 24022515) |
| **Network** | HTTPS (443) to SDDC Manager, DNS resolution |

## Installation

### Prerequisites

```powershell
# 1. Verify PowerShell version (7.2+ required)
$PSVersionTable.PSVersion

# 2. Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Install NuGet provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# 4. Trust PowerShell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# 5. Install .NET 6.0+ (if not present)
# Download from: https://dotnet.microsoft.com/download/dotnet/6.0
```

### VMware PowerCLI Installation

#### Online Installation (Recommended)
```powershell
# Install VMware PowerCLI (base requirement)
Install-Module -Name VMware.PowerCLI -MinimumVersion 13.3.0 -Scope CurrentUser -Force

# Install VCF PowerCLI (VCF-specific cmdlets)
Install-Module -Name VCF.PowerCLI -RequiredVersion 9.0.0.24798382 -Scope CurrentUser -Force

# Verify installation
Get-Module -Name VMware.PowerCLI, VCF.PowerCLI -ListAvailable | Select-Object Name, Version

# Import modules
Import-Module VMware.PowerCLI, VCF.PowerCLI
```

#### Offline Installation
```powershell
# Download modules
Save-Module -Name VCF.PowerCLI -Path "C:\Temp\VCF-PowerCLI" -Repository PSGallery

# Install from local path
Install-Module -Name VCF.PowerCLI -Repository PSGallery -Force
```

### Post-Installation Setup

```powershell
# Configure PowerCLI settings
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope Session
Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false -Scope Session
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false -Scope Session
```

## Configuration

### Secure Credential Storage

```powershell
# Method 1: Windows Credential Manager (Recommended)
$credential = Get-Credential -Message "Enter VCF SDDC Manager credentials"
$credential | Export-Clixml -Path "$env:USERPROFILE\Documents\vcf-credentials.xml"

# Method 2: Environment Variables (Development only)
$env:VCF_SERVER = "vcf-mgmt01.domain.local"
$env:VCF_USERNAME = "administrator@vsphere.local"
```

### Environment Configuration

Create `config.json` (excluded from git):
```json
{
  "sddcManager": "vcf-mgmt01.domain.local",
  "domain": "domain.local",
  "logLevel": "Info",
  "timeout": 300
}
```

## Usage Examples

### Basic Connection
```powershell
# Load stored credentials
$credential = Import-Clixml -Path "$env:USERPROFILE\Documents\vcf-credentials.xml"

# Connect to SDDC Manager
.\examples\Connect-VCF.ps1 -Server "vcf-mgmt01.domain.local" -Credential $credential
```

### Infrastructure Monitoring
```powershell
# Get comprehensive inventory
.\examples\Get-VCFInventory.ps1 -OutputPath "C:\Reports\vcf-inventory.csv"

# Perform health checks
.\examples\Get-VCFHealthStatus.ps1

# Get system information
.\examples\Get-VCFSystemInfo.ps1
```

**More Examples**: See the [examples](./examples/) directory for comprehensive usage scenarios.

## Component Guides

PowerCLI examples and connection guides organized by VMware components:

### Core Infrastructure
- **[vSphere & vSAN](./docs/Getting-Started-vSphere-vSAN.md)** - Virtual infrastructure management and hyper-converged storage
- **[NSX-T Data Center](./docs/Getting-Started-NSX-T-Data-Center.md)** - Network virtualization and security
- **[VCF SDDC Manager](./docs/Getting-Started-VCF-SDDC-Manager.md)** - Cloud Foundation lifecycle management

### Cloud Services
- **[vCloud Director](./docs/Getting-Started-vCloud-Director.md)** - Multi-tenant cloud infrastructure
- **[VMware Cloud Services](./docs/Getting-Started-VMware-Cloud-Services.md)** - Cloud services platform management
- **[VMware Cloud on AWS](./docs/Getting-Started-VMware-Cloud-On-AWS.md)** - Hybrid cloud on Amazon Web Services

### Operations & Management
- **[vRealize Operations Manager](./docs/Getting-Started-vRealize-Operations-Manager.md)** - Performance monitoring and analytics
- **[Site Recovery Manager](./docs/Getting-Started-Site-Recovery-Manager.md)** - Disaster recovery automation
- **[VMware HCX](./docs/Getting-Started-VMware-HCX.md)** - Hybrid cloud extension and migration

## Security

### Security Features
- **Secure Credential Storage** - Windows Credential Manager integration
- **Input Validation** - Comprehensive parameter validation
- **Error Handling** - Robust exception management
- **Audit Logging** - Detailed operation logging
- **No Hardcoded Secrets** - Zero embedded credentials

### Security Scanning
| Tool | Status | Purpose |
|------|--------|----------|
| PSScriptAnalyzer | Active | PowerShell best practices |
| GitHub CodeQL | Active | Security vulnerability detection |
| Dependabot | Active | Dependency security updates |

### Security Guidelines
- Never commit credentials or API keys
- Use secure credential storage methods
- Validate all input parameters
- Implement proper error handling
- Enable audit logging for compliance

---

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Issues & Feature Requests
- [Report Bug](https://github.com/uldyssian-sh/vmware-vcf-powercli/issues/new?template=bug_report.md)
- [Request Feature](https://github.com/uldyssian-sh/vmware-vcf-powercli/issues/new?template=feature_request.md)

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**VMware Cloud Foundation PowerCLI Guide**

**Data Source Reference**: [https://developer.broadcom.com/powercli](https://developer.broadcom.com/powercli)

[Back to Top](#vmware-cloud-foundation-powercli-guide)



**FREE GitHub AI Features:**
- 🤖 GitHub Copilot integration
- 🔒 AI security scanning
- 📦 Smart dependency updates
- 🛡️ Automated vulnerability detection
