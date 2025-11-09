<#
.SYNOPSIS
    Get VMware Cloud Foundation 9.0 system information

.DESCRIPTION
    Retrieves comprehensive system information from VCF 9.0 environment

.EXAMPLE
    Get-VCFSystemInfo

.NOTES
    Requires VCF.PowerCLI 9.0 and active connection to SDDC Manager
#>

[CmdletBinding()]
param()

try {
    # Verify connection
    $manager = Get-VCFManager -ErrorAction Stop
    
    Write-Host "=== VMware Cloud Foundation 9.0 System Information ===" -ForegroundColor Cyan
    Write-Host ""
    
    # SDDC Manager Info
    Write-Host "SDDC Manager:" -ForegroundColor Yellow
    Write-Host "  FQDN: $($manager.fqdn)" -ForegroundColor White
    Write-Host "  Version: $($manager.version)" -ForegroundColor White
    Write-Host "  Build: $($manager.buildNumber)" -ForegroundColor White
    Write-Host ""
    
    # Workload Domains
    $domains = Get-VCFWorkloadDomain
    Write-Host "Workload Domains ($($domains.Count)):" -ForegroundColor Yellow
    foreach ($domain in $domains) {
        Write-Host "  - $($domain.name) [$($domain.type)]" -ForegroundColor White
        Write-Host "    Status: $($domain.status)" -ForegroundColor $(if ($domain.status -eq "ACTIVE") { "Green" } else { "Red" })
    }
    Write-Host ""
    
    # Clusters
    $clusters = Get-VCFCluster
    Write-Host "Clusters ($($clusters.Count)):" -ForegroundColor Yellow
    foreach ($cluster in $clusters) {
        Write-Host "  - $($cluster.name)" -ForegroundColor White
        Write-Host "    Hosts: $($cluster.hosts.Count)" -ForegroundColor White
    }
    Write-Host ""
    
    # Hosts
    $hosts = Get-VCFHost
    Write-Host "ESXi Hosts ($($hosts.Count)):" -ForegroundColor Yellow
    foreach ($host in $hosts) {
        Write-Host "  - $($host.fqdn)" -ForegroundColor White
        Write-Host "    Status: $($host.status)" -ForegroundColor $(if ($host.status -eq "ASSIGNED") { "Green" } else { "Yellow" })
    }
    Write-Host ""
    
    # Network Pools
    $networkPools = Get-VCFNetworkPool
    Write-Host "Network Pools ($($networkPools.Count)):" -ForegroundColor Yellow
    foreach ($pool in $networkPools) {
        Write-Host "  - $($pool.name)" -ForegroundColor White
    }
    Write-Host ""
    
    # Certificates
    $certificates = Get-VCFCertificate
    Write-Host "Certificates:" -ForegroundColor Yellow
    $expiringSoon = $certificates | Where-Object { 
        $_.notAfter -and (Get-Date $_.notAfter) -lt (Get-Date).AddDays(30) 
    }
    if ($expiringSoon) {
        Write-Host "  ⚠️  $($expiringSoon.Count) certificate(s) expiring within 30 days" -ForegroundColor Red
    } else {
        Write-Host "  ✅ All certificates valid" -ForegroundColor Green
    }
    
    return @{
        Manager = $manager
        Domains = $domains
        Clusters = $clusters
        Hosts = $hosts
        NetworkPools = $networkPools
        Certificates = $certificates
    }
}
catch {
    Write-Error "Failed to retrieve system information: $($_.Exception.Message)"
    throw
}# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
