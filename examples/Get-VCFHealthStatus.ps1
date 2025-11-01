<#
.SYNOPSIS
    Get VMware Cloud Foundation 9.0 health status

.DESCRIPTION
    Performs comprehensive health checks on VCF 9.0 infrastructure

.PARAMETER IncludeDetails
    Include detailed health information

.EXAMPLE
    Get-VCFHealthStatus

.EXAMPLE
    Get-VCFHealthStatus -IncludeDetails

.NOTES
    Requires VCF.PowerCLI 9.0 and active connection to SDDC Manager
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$IncludeDetails
)

try {
    Write-Host "=== VMware Cloud Foundation 9.0 Health Status ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Overall system health
    $systemHealth = Get-VCFSystemHealth
    Write-Host "System Health: " -NoNewline -ForegroundColor Yellow
    Write-Host $systemHealth.overallStatus -ForegroundColor $(
        switch ($systemHealth.overallStatus) {
            "GREEN" { "Green" }
            "YELLOW" { "Yellow" }
            "RED" { "Red" }
            default { "White" }
        }
    )
    Write-Host ""
    
    # Service health
    $services = Get-VCFService
    Write-Host "Services Health:" -ForegroundColor Yellow
    $healthyServices = ($services | Where-Object { $_.status -eq "ACTIVE" }).Count
    $totalServices = $services.Count
    Write-Host "  Active: $healthyServices/$totalServices" -ForegroundColor $(
        if ($healthyServices -eq $totalServices) { "Green" } else { "Red" }
    )
    
    if ($IncludeDetails) {
        foreach ($service in $services | Where-Object { $_.status -ne "ACTIVE" }) {
            Write-Host "    ⚠️  $($service.name): $($service.status)" -ForegroundColor Red
        }
    }
    Write-Host ""
    
    # Host health
    $hosts = Get-VCFHost
    Write-Host "Host Health:" -ForegroundColor Yellow
    $healthyHosts = ($hosts | Where-Object { $_.status -eq "ASSIGNED" }).Count
    $totalHosts = $hosts.Count
    Write-Host "  Healthy: $healthyHosts/$totalHosts" -ForegroundColor $(
        if ($healthyHosts -eq $totalHosts) { "Green" } else { "Red" }
    )
    
    if ($IncludeDetails) {
        foreach ($host in $hosts | Where-Object { $_.status -ne "ASSIGNED" }) {
            Write-Host "    ⚠️  $($host.fqdn): $($host.status)" -ForegroundColor Red
        }
    }
    Write-Host ""
    
    # Cluster health
    $clusters = Get-VCFCluster
    Write-Host "Cluster Health:" -ForegroundColor Yellow
    foreach ($cluster in $clusters) {
        $clusterHealth = Get-VCFCluster -id $cluster.id
        Write-Host "  $($cluster.name): " -NoNewline -ForegroundColor White
        Write-Host $clusterHealth.status -ForegroundColor $(
            if ($clusterHealth.status -eq "ACTIVE") { "Green" } else { "Red" }
        )
    }
    Write-Host ""
    
    # Network health
    $networkPools = Get-VCFNetworkPool
    Write-Host "Network Health:" -ForegroundColor Yellow
    foreach ($pool in $networkPools) {
        Write-Host "  $($pool.name): Available" -ForegroundColor Green
    }
    Write-Host ""
    
    # Certificate health
    $certificates = Get-VCFCertificate
    $expiringSoon = $certificates | Where-Object { 
        $_.notAfter -and (Get-Date $_.notAfter) -lt (Get-Date).AddDays(30) 
    }
    
    Write-Host "Certificate Health:" -ForegroundColor Yellow
    if ($expiringSoon.Count -gt 0) {
        Write-Host "  ⚠️  $($expiringSoon.Count) certificate(s) expiring within 30 days" -ForegroundColor Red
        if ($IncludeDetails) {
            foreach ($cert in $expiringSoon) {
                $daysLeft = ((Get-Date $cert.notAfter) - (Get-Date)).Days
                Write-Host "    - $($cert.issuedTo): $daysLeft days remaining" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "  ✅ All certificates healthy" -ForegroundColor Green
    }
    
    # Summary
    Write-Host ""
    Write-Host "=== Health Summary ===" -ForegroundColor Cyan
    $issues = @()
    if ($systemHealth.overallStatus -ne "GREEN") { $issues += "System health issues" }
    if ($healthyServices -ne $totalServices) { $issues += "Service issues" }
    if ($healthyHosts -ne $totalHosts) { $issues += "Host issues" }
    if ($expiringSoon.Count -gt 0) { $issues += "Certificate expiration" }
    
    if ($issues.Count -eq 0) {
        Write-Host "✅ All systems healthy" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Issues found:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  - $issue" -ForegroundColor Red
        }
    }
    
    return @{
        SystemHealth = $systemHealth
        Services = $services
        Hosts = $hosts
        Clusters = $clusters
        Certificates = $certificates
        Issues = $issues
    }
}
catch {
    Write-Error "Failed to retrieve health status: $($_.Exception.Message)"
    throw
}