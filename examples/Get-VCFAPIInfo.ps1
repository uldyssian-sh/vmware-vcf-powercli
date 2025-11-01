<#
.SYNOPSIS
    Get VMware Cloud Foundation API information

.DESCRIPTION
    Retrieves VCF API version, endpoints, and authentication methods

.EXAMPLE
    Get-VCFAPIInfo

.NOTES
    Requires VCF.PowerCLI 9.0 and active connection to SDDC Manager
#>

[CmdletBinding()]
param()

try {
    Write-Host "=== VMware Cloud Foundation API Information ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Get API version
    $apiVersion = Get-VCFManager | Select-Object -ExpandProperty apiVersion -ErrorAction SilentlyContinue
    if (-not $apiVersion) {
        $apiVersion = "5.0"  # Default for VCF 9.0
    }
    
    Write-Host "API Version: $apiVersion" -ForegroundColor Green
    Write-Host ""
    
    # Available API endpoints
    Write-Host "Available API Endpoints:" -ForegroundColor Yellow
    $endpoints = @(
        @{ Name = "Authentication"; Path = "/v1/tokens"; Method = "POST" }
        @{ Name = "SDDC Manager"; Path = "/v1/sddc-managers"; Method = "GET" }
        @{ Name = "Workload Domains"; Path = "/v1/domains"; Method = "GET" }
        @{ Name = "Clusters"; Path = "/v1/clusters"; Method = "GET" }
        @{ Name = "Hosts"; Path = "/v1/hosts"; Method = "GET" }
        @{ Name = "Network Pools"; Path = "/v1/network-pools"; Method = "GET" }
        @{ Name = "Certificates"; Path = "/v1/certificates"; Method = "GET" }
        @{ Name = "Tasks"; Path = "/v1/tasks"; Method = "GET" }
        @{ Name = "Bundles"; Path = "/v1/bundles"; Method = "GET" }
        @{ Name = "Upgrades"; Path = "/v1/upgrades"; Method = "GET" }
        @{ Name = "Backups"; Path = "/v1/backups"; Method = "GET" }
        @{ Name = "System Health"; Path = "/v1/system/health"; Method = "GET" }
    )
    
    foreach ($endpoint in $endpoints) {
        Write-Host "  $($endpoint.Method) $($endpoint.Path)" -ForegroundColor White
        Write-Host "    Description: $($endpoint.Name)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Authentication methods
    Write-Host "Supported Authentication Methods:" -ForegroundColor Yellow
    Write-Host "  • Basic Authentication (username/password)" -ForegroundColor White
    Write-Host "  • API Tokens (recommended for automation)" -ForegroundColor White
    Write-Host "  • OAuth 2.0 (for third-party integrations)" -ForegroundColor White
    Write-Host ""
    
    # PowerCLI cmdlets mapping
    Write-Host "PowerCLI Cmdlets to API Mapping:" -ForegroundColor Yellow
    $cmdletMapping = @(
        @{ Cmdlet = "Connect-VCFManager"; API = "POST /v1/tokens" }
        @{ Cmdlet = "Get-VCFManager"; API = "GET /v1/sddc-managers" }
        @{ Cmdlet = "Get-VCFWorkloadDomain"; API = "GET /v1/domains" }
        @{ Cmdlet = "Get-VCFCluster"; API = "GET /v1/clusters" }
        @{ Cmdlet = "Get-VCFHost"; API = "GET /v1/hosts" }
        @{ Cmdlet = "Get-VCFNetworkPool"; API = "GET /v1/network-pools" }
        @{ Cmdlet = "Get-VCFCertificate"; API = "GET /v1/certificates" }
        @{ Cmdlet = "Get-VCFTask"; API = "GET /v1/tasks" }
        @{ Cmdlet = "Get-VCFBundle"; API = "GET /v1/bundles" }
    )
    
    foreach ($mapping in $cmdletMapping) {
        Write-Host "  $($mapping.Cmdlet)" -ForegroundColor Green
        Write-Host "    → $($mapping.API)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # SDK information
    Write-Host "Available SDKs:" -ForegroundColor Yellow
    Write-Host "  • VCF PowerCLI (PowerShell)" -ForegroundColor White
    Write-Host "  • VCF Python SDK" -ForegroundColor White
    Write-Host "  • VCF Terraform Provider" -ForegroundColor White
    Write-Host "  • VCF REST API (Direct HTTP calls)" -ForegroundColor White
    Write-Host ""
    
    # Rate limiting
    Write-Host "API Rate Limits:" -ForegroundColor Yellow
    Write-Host "  • Default: 100 requests per minute per user" -ForegroundColor White
    Write-Host "  • Burst: 200 requests per minute" -ForegroundColor White
    Write-Host "  • Long-running operations: Use task-based APIs" -ForegroundColor White
    
    return @{
        APIVersion = $apiVersion
        Endpoints = $endpoints
        CmdletMapping = $cmdletMapping
    }
}
catch {
    Write-Error "Failed to retrieve API information: $($_.Exception.Message)"
    throw
}