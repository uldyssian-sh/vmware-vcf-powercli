<#
.SYNOPSIS
    VMware Cloud Foundation PowerCLI Automation Module

.DESCRIPTION
    PowerShell module for VMware Cloud Foundation automation tasks

.NOTES
    Requires VCF.PowerCLI 9.0 or later
#>

function Connect-VCFEnvironment {
    <#
    .SYNOPSIS
        Connect to VCF SDDC Manager with error handling
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FQDN,
        
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )
    
    try {
        Import-Module VCF.PowerCLI -ErrorAction Stop
        $connection = Connect-VCFManager -fqdn $FQDN -credential $Credential
        Write-Host "Connected to $FQDN" -ForegroundColor Green
        return $connection
    }
    catch {
        Write-Error "Connection failed: $($_.Exception.Message)"
        throw
    }
}

function Get-VCFEnvironmentHealth {
    <#
    .SYNOPSIS
        Get comprehensive VCF environment health status
    #>
    [CmdletBinding()]
    param()
    
    try {
        $health = @{
            SystemHealth = Get-VCFSystemHealth
            Services = Get-VCFService
            Hosts = Get-VCFHost
            Clusters = Get-VCFCluster
        }
        
        return $health
    }
    catch {
        Write-Error "Health check failed: $($_.Exception.Message)"
        throw
    }
}

Export-ModuleMember -Function Connect-VCFEnvironment, Get-VCFEnvironmentHealth# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692694
