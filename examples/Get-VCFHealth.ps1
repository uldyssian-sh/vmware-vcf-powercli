<#
.SYNOPSIS
    Get VMware Cloud Foundation health status

.DESCRIPTION
    Performs health checks on VCF infrastructure components

.PARAMETER IncludeVMs
    Include VM health in the report

.EXAMPLE
    Get-VCFHealth

.EXAMPLE
    Get-VCFHealth -IncludeVMs

.NOTES
    Requires active connection to SDDC Manager
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$IncludeVMs
)

try {
    # Verify connection
    if (-not $global:DefaultVIServers) {
        throw "No active connection to SDDC Manager. Use Connect-VCF first."
    }
    
    Write-Host "Performing VCF health checks..." -ForegroundColor Yellow
    
    $healthReport = @()
    
    # Check ESXi hosts
    $hosts = Get-VMHost
    foreach ($host in $hosts) {
        $healthReport += [PSCustomObject]@{
            Component = "ESXi Host"
            Name = $host.Name
            Status = $host.ConnectionState
            PowerState = $host.PowerState
            Version = $host.Version
            Build = $host.Build
            Issues = if ($host.ConnectionState -ne "Connected") { "Connection Issue" } else { "None" }
        }
    }
    
    # Check clusters
    $clusters = Get-Cluster
    foreach ($cluster in $clusters) {
        $healthReport += [PSCustomObject]@{
            Component = "Cluster"
            Name = $cluster.Name
            Status = if ($cluster.HAEnabled -and $cluster.DrsEnabled) { "Healthy" } else { "Warning" }
            PowerState = "N/A"
            Version = "N/A"
            Build = "N/A"
            Issues = @(
                if (-not $cluster.HAEnabled) { "HA Disabled" }
                if (-not $cluster.DrsEnabled) { "DRS Disabled" }
            ) -join ", "
        }
    }
    
    # Check VMs if requested
    if ($IncludeVMs) {
        $vms = Get-VM | Where-Object { $_.PowerState -ne "PoweredOn" }
        foreach ($vm in $vms) {
            $healthReport += [PSCustomObject]@{
                Component = "Virtual Machine"
                Name = $vm.Name
                Status = "Warning"
                PowerState = $vm.PowerState
                Version = $vm.Version
                Build = "N/A"
                Issues = "VM not powered on"
            }
        }
    }
    
    # Display results
    $healthReport | Format-Table -AutoSize
    
    # Summary
    $totalIssues = ($healthReport | Where-Object { $_.Issues -ne "None" }).Count
    Write-Host "`nHealth Summary:" -ForegroundColor Cyan
    Write-Host "Total Components Checked: $($healthReport.Count)" -ForegroundColor White
    Write-Host "Components with Issues: $totalIssues" -ForegroundColor $(if ($totalIssues -eq 0) { "Green" } else { "Red" })
    
    return $healthReport
}
catch {
    Write-Error "Failed to perform health check: $($_.Exception.Message)"
    throw
