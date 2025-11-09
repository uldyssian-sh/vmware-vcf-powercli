<#
.SYNOPSIS
    Connect to VMware Cloud Foundation SDDC Manager

.DESCRIPTION
    Establishes secure connection to VCF SDDC Manager using PowerCLI

.PARAMETER Server
    FQDN or IP address of SDDC Manager

.PARAMETER Credential
    PSCredential object for authentication

.EXAMPLE
    Connect-VCF -Server "vcf-mgmt01.domain.local" -Credential $cred

.NOTES
    Requires VMware PowerCLI 13.0 or later
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Server,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]$Credential
)

try {
    # Import required modules
    Import-Module VMware.PowerCLI -ErrorAction Stop
    
    # Set PowerCLI configuration
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope Session
    Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false -Scope Session
    
    # Connect to SDDC Manager
    Write-Host "Connecting to SDDC Manager: $Server" -ForegroundColor Green
    $connection = Connect-VIServer -Server $Server -Credential $Credential -ErrorAction Stop
    
    Write-Host "Successfully connected to $($connection.Name)" -ForegroundColor Green
    return $connection
}
catch {
    Write-Error "Failed to connect to SDDC Manager: $($_.Exception.Message)"
    throw
}# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692693
