<#
.SYNOPSIS
    Connect to VMware Cloud Foundation SDDC Manager

.DESCRIPTION
    Establishes secure connection to VCF SDDC Manager using VCF.PowerCLI module

.PARAMETER FQDN
    FQDN of SDDC Manager

.PARAMETER Credential
    PSCredential object for authentication

.EXAMPLE
    Connect-VCFManager -FQDN "vcf-mgmt01.domain.local" -Credential $cred

.NOTES
    Requires VCF.PowerCLI 9.0 or later
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$FQDN,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]$Credential
)

try {
    # Import required modules
    Import-Module VCF.PowerCLI -ErrorAction Stop
    
    # Connect to SDDC Manager
    Write-Host "Connecting to SDDC Manager: $FQDN" -ForegroundColor Green
    $connection = Connect-VCFManager -fqdn $FQDN -credential $Credential -ErrorAction Stop
    
    Write-Host "Successfully connected to $FQDN" -ForegroundColor Green
    
    # Verify connection
    $version = Get-VCFManager
    Write-Host "VCF Version: $($version.version)" -ForegroundColor Cyan
    
    return $connection
}
catch {
    Write-Error "Failed to connect to SDDC Manager: $($_.Exception.Message)"
    throw
