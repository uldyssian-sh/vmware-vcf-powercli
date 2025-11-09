# VMware VCF PowerCLI Examples

This directory contains practical examples for managing VMware Cloud Foundation environments using PowerCLI.

## Available Examples

### Connection Management
- **Connect-VCF.ps1** - Secure connection to SDDC Manager
- **Disconnect-VCF.ps1** - Proper disconnection and cleanup

### Inventory Management
- **Get-VCFInventory.ps1** - Comprehensive inventory reporting
- **Export-VCFConfiguration.ps1** - Export current configuration

### Health Monitoring
- **Get-VCFHealth.ps1** - Infrastructure health checks
- **Test-VCFConnectivity.ps1** - Network connectivity validation

### Workload Domain Management
- **New-WorkloadDomain.ps1** - Create new workload domains
- **Get-WorkloadDomainInfo.ps1** - Retrieve domain information

### Host Management
- **Add-ESXiHost.ps1** - Add ESXi hosts to clusters
- **Remove-ESXiHost.ps1** - Safely remove hosts

### Certificate Management
- **Get-VCFCertificates.ps1** - Certificate inventory and status
- **Update-VCFCertificates.ps1** - Certificate renewal automation

## Usage Guidelines

1. **Prerequisites**: Ensure VMware PowerCLI is installed and configured
2. **Authentication**: Use secure credential storage methods
3. **Error Handling**: All scripts include comprehensive error handling
4. **Logging**: Enable logging for audit and troubleshooting
5. **Testing**: Test scripts in non-production environments first

## Security Notes

- Never hardcode credentials in scripts
- Use Windows Credential Manager or secure vaults
- Validate all input parameters
- Implement proper error handling
- Log security-relevant events

## Getting Started

```powershell
# 1. Load credentials securely
$credential = Get-Credential

# 2. Connect to SDDC Manager
.\Connect-VCF.ps1 -Server "vcf-mgmt01.domain.local" -Credential $credential

# 3. Run inventory check
.\Get-VCFInventory.ps1

# 4. Perform health check
.\Get-VCFHealth.ps1 -IncludeVMs
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
