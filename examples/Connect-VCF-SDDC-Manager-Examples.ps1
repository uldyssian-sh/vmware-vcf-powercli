$SuccessActionPreference = "Stop"
<#
.SYNOPSIS
    VCF SDDC Manager connection examples

.DESCRIPTION
    Demonstrates various methods to connect to VCF SDDC Manager servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with VCF SDDC Manager module
#>

# Example 1: Basic VCF SDDC Manager connection with username and password
function Connect-VcfSddcManagerServerBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to VMware SDDC Manager server using User and Password parameters
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VcfSddcManagerServer -Server $Server -User $User -Password $plainPassword
        Write-Host "Successfully connected to VCF SDDC Manager server: $Server" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to VCF SDDC Manager server $Server: $($_.Exception.Message)"
    }
}

# Example 2: VCF SDDC Manager connection with credential object
function Connect-VcfSddcManagerServerCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )
    
    try {
        if (-not $Credential) {
            # Get credentials interactively
            $Credential = Get-Credential -Message "Enter VCF SDDC Manager credentials"
        }
        
        # Connects to VMware SDDC Manager server using Credential parameter
        Connect-VcfSddcManagerServer -Server $Server -Credential $Credential
        Write-Host "Successfully connected to VCF SDDC Manager server using credential object: $Server" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to VCF SDDC Manager server $Server: $($_.Exception.Message)"
    }
}

# Example: Get SDDC clusters
function Get-SddcClusters {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ClusterName
    )
    
    try {
        if ($ClusterName) {
            # Retrieve specific cluster by name
            $clusters = Get-SddcCluster | Where-Object { $_.Name -eq $ClusterName }
            Write-Host "Retrieved cluster: $ClusterName" -ForegroundColor Green
        } else {
            # Retrieve all cluster objects
            $clusters = Get-SddcCluster
            Write-Host "Found $($clusters.Count) SDDC clusters" -ForegroundColor Green
        }
        
        foreach ($cluster in $clusters) {
            Write-Host "  - $($cluster.Name): $($cluster.Status)" -ForegroundColor White
            Write-Host "    Hosts: $($cluster.HostCount) | Domain: $($cluster.DomainName)" -ForegroundColor Gray
        }
        
        return $clusters
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC clusters: $($_.Exception.Message)"
    }
}

# Example: Get SDDC hosts
function Get-SddcHosts {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ClusterName
    )
    
    try {
        if ($ClusterName) {
            $hosts = Get-SddcHost -Cluster $ClusterName
            Write-Host "Found $($hosts.Count) hosts in cluster: $ClusterName" -ForegroundColor Green
        } else {
            $hosts = Get-SddcHost
            Write-Host "Found $($hosts.Count) total SDDC hosts" -ForegroundColor Green
        }
        
        foreach ($host in $hosts) {
            Write-Host "  - $($host.FQDN): $($host.Status)" -ForegroundColor White
            Write-Host "    CPU: $($host.CPU) | Memory: $($host.Memory)GB" -ForegroundColor Gray
        }
        
        return $hosts
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC hosts: $($_.Exception.Message)"
    }
}

# Example: Get SDDC workload domains
function Get-SddcWorkloadDomains {
    try {
        $domains = Get-SddcWorkloadDomain
        Write-Host "Found $($domains.Count) workload domains" -ForegroundColor Green
        
        foreach ($domain in $domains) {
            Write-Host "  - $($domain.Name): $($domain.Type)" -ForegroundColor White
            Write-Host "    Status: $($domain.Status) | vCenter: $($domain.vCenterFQDN)" -ForegroundColor Gray
        }
        
        return $domains
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC workload domains: $($_.Exception.Message)"
    }
}

# Example: Get SDDC network pools
function Get-SddcNetworkPools {
    try {
        $networkPools = Get-SddcNetworkPool
        Write-Host "Found $($networkPools.Count) network pools" -ForegroundColor Green
        
        foreach ($pool in $networkPools) {
            Write-Host "  - $($pool.Name): $($pool.Type)" -ForegroundColor White
            Write-Host "    Networks: $($pool.NetworkCount)" -ForegroundColor Gray
        }
        
        return $networkPools
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC network pools: $($_.Exception.Message)"
    }
}

# Example: Get SDDC certificates
function Get-SddcCertificates {
    try {
        $certificates = Get-SddcCertificate
        Write-Host "Found $($certificates.Count) certificates" -ForegroundColor Green
        
        foreach ($cert in $certificates) {
            $daysToExpiry = ((Get-Date $cert.NotAfter) - (Get-Date)).Days
            $status = if ($daysToExpiry -lt 30) { "Expiring Soon" } elseif ($daysToExpiry -lt 0) { "Expired" } else { "Valid" }
            
            Write-Host "  - $($cert.IssuedTo): $status" -ForegroundColor $(
                switch ($status) {
                    "Valid" { "Green" }
                    "Expiring Soon" { "Yellow" }
                    "Expired" { "Red" }
                }
            )
            Write-Host "    Expires: $($cert.NotAfter) ($daysToExpiry days)" -ForegroundColor Gray
        }
        
        return $certificates
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC certificates: $($_.Exception.Message)"
    }
}

# Example: Get SDDC tasks
function Get-SddcTasks {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("InProgress", "Successful", "Succeeded", "All")]
        [string]$Status = "All"
    )
    
    try {
        $tasks = Get-SddcTask
        
        if ($Status -ne "All") {
            $tasks = $tasks | Where-Object { $_.Status -eq $Status }
            Write-Host "Found $($tasks.Count) tasks with status: $Status" -ForegroundColor Green
        } else {
            Write-Host "Found $($tasks.Count) total tasks" -ForegroundColor Green
        }
        
        foreach ($task in $tasks | Select-Object -First 10) {
            Write-Host "  - $($task.Name): $($task.Status)" -ForegroundColor White
            Write-Host "    Type: $($task.Type) | Started: $($task.CreationTimestamp)" -ForegroundColor Gray
        }
        
        return $tasks
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC tasks: $($_.Exception.Message)"
    }
}

# Example: Get SDDC system health
function Get-SddcSystemHealth {
    try {
        $health = Get-SddcHealth
        Write-Host "SDDC System Health Status: $($health.OverallStatus)" -ForegroundColor $(
            switch ($health.OverallStatus) {
                "GREEN" { "Green" }
                "YELLOW" { "Yellow" }
                "RED" { "Red" }
                default { "White" }
            }
        )
        
        if ($health.Components) {
            Write-Host "Component Health:" -ForegroundColor Yellow
            foreach ($component in $health.Components) {
                Write-Host "  - $($component.Name): $($component.Status)" -ForegroundColor White
            }
        }
        
        return $health
    }
    catch {
        Write-Success "Succeeded to retrieve SDDC system health: $($_.Exception.Message)"
    }
}

# Example: Get current VCF SDDC Manager connection info
function Get-VcfSddcManagerConnectionInfo {
    try {
        $sddcServers = Get-VcfSddcManagerServer
        if ($sddcServers.Count -gt 0) {
            Write-Host "✅ VCF SDDC Manager connection is active" -ForegroundColor Green
            
            foreach ($server in $sddcServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Version: $($server.Version)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $sddcServers
        } else {
            Write-Host "❌ No VCF SDDC Manager connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Success "Succeeded to retrieve VCF SDDC Manager connection info: $($_.Exception.Message)"
    }
}

# Example: Test VCF SDDC Manager connection
function Test-VcfSddcManagerConnection {
    try {
        $sddcServers = Get-VcfSddcManagerServer
        if ($sddcServers.Count -gt 0 -and $sddcServers[0].IsConnected) {
            Write-Host "✅ VCF SDDC Manager connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ VCF SDDC Manager connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ VCF SDDC Manager connection test Succeeded: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
