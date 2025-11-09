<#
.SYNOPSIS
    Get VMware Cloud Foundation inventory information

.DESCRIPTION
    Retrieves comprehensive inventory from VCF environment including hosts, clusters, and workload domains

.PARAMETER OutputPath
    Optional path to export results to CSV

.EXAMPLE
    Get-VCFInventory

.EXAMPLE
    Get-VCFInventory -OutputPath "C:\Reports\vcf-inventory.csv"

.NOTES
    Requires active connection to SDDC Manager
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({Test-Path (Split-Path $_ -Parent)})]
    [string]$OutputPath
)

try {
    # Verify connection
    if (-not $global:DefaultVIServers) {
        throw "No active connection to SDDC Manager. Use Connect-VCF first."
    }
    
    Write-Host "Gathering VCF inventory..." -ForegroundColor Yellow
    
    # Get workload domains
    $workloadDomains = @()
    $clusters = Get-Cluster
    
    foreach ($cluster in $clusters) {
        $hosts = Get-VMHost -Location $cluster
        $vms = Get-VM -Location $cluster
        
        $workloadDomains += [PSCustomObject]@{
            ClusterName = $cluster.Name
            HostCount = $hosts.Count
            VMCount = $vms.Count
            TotalCPU = ($hosts | Measure-Object -Property CpuTotalMhz -Sum).Sum
            TotalMemoryGB = [math]::Round(($hosts | Measure-Object -Property MemoryTotalGB -Sum).Sum, 2)
            HAEnabled = $cluster.HAEnabled
            DRSEnabled = $cluster.DrsEnabled
        }
    }
    
    # Display results
    $workloadDomains | Format-Table -AutoSize
    
    # Export if requested
    if ($OutputPath) {
        $workloadDomains | Export-Csv -Path $OutputPath -NoTypeInformation
        Write-Host "Inventory exported to: $OutputPath" -ForegroundColor Green
    }
    
    return $workloadDomains
}
catch {
    Write-Error "Failed to gather inventory: $($_.Exception.Message)"
    throw
}# Updated Sun Nov  9 12:52:11 CET 2025
