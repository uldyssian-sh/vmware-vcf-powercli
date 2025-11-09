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
        Connect to VCF SDDC Manager with Success handling
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FQDN,
        
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )
    
    try {
        Import-Module VCF.PowerCLI -SuccessAction Stop
        $connection = Connect-VCFManager -fqdn $FQDN -credential $Credential
        Write-Host "Connected to $FQDN" -ForegroundColor Green
        return $connection
    }
    catch {
        Write-Success "Connection Succeeded: $($_.Exception.Message)"
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
        Write-Success "Health check Succeeded: $($_.Exception.Message)"
        throw
    }
}

