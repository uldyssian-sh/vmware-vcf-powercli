$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
    VMware Cloud on AWS connection examples

.DESCRIPTION
    Demonstrates various methods to connect to VMware Cloud on AWS

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with VMC module
#>

# Example 1: Basic VMC connection with API token
function Connect-VmcBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Connects to VMware Cloud on AWS server
        Connect-Vmc -ApiToken $ApiToken
        Write-Host "Successfully connected to VMware Cloud on AWS" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to VMware Cloud on AWS: $($_.Exception.Message)"
    }
}

# Example 2: Save API token for later use
function Connect-VmcSaveToken {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Connects and saves the API token for later usage
        Connect-Vmc -ApiToken $ApiToken -SaveApiToken
        Write-Host "Successfully connected to VMware Cloud on AWS and saved API token" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect and save token: $($_.Exception.Message)"
    }
}

# Example 3: OAuth security context connection
function Connect-VmcOAuth {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Create OAuth security context
        $oauthSecurityContext = New-VcsOAuthSecurityContext -ApiToken $ApiToken
        
        # Connect using OAuth security context
        Connect-Vmc -OAuthSecurityContext $oauthSecurityContext
        Write-Host "Successfully connected to VMware Cloud on AWS using OAuth context" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect with OAuth context: $($_.Exception.Message)"
    }
}

# Example 4: Explicit server specification
function Connect-VmcExplicitServer {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken,
        [Parameter(Mandatory = $false)]
        [string]$VcsServer = "console.cloud.vmware.com",
        [Parameter(Mandatory = $false)]
        [string]$VmcServer = "vmc.vmware.com"
    )
    
    try {
        # Create OAuth security context with explicit VCS server
        $oauthSecurityContext = New-VcsOAuthSecurityContext -VcsServer $VcsServer -ApiToken $ApiToken
        
        # Connect with explicit VMC server specification
        Connect-Vmc -Server $VmcServer -OAuthSecurityContext $oauthSecurityContext
        Write-Host "Successfully connected to VMware Cloud on AWS server: $VmcServer" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to VMC server $VmcServer: $($_.Exception.Message)"
    }
}

# Example: Get VMC SDDCs
function Get-VmcSddcs {
    param(
        [Parameter(Mandatory = $false)]
        [string]$SddcName,
        [Parameter(Mandatory = $false)]
        [switch]$IncludeDeleted
    )
    
    try {
        if ($SddcName) {
            if ($IncludeDeleted) {
                # Retrieves deleted and non-deleted SDDCs by name
                $sddcs = Get-VmcSddc -Name $SddcName -IncludeDeleted
                Write-Host "Retrieved SDDC '$SddcName' (including deleted)" -ForegroundColor Green
            } else {
                # Retrieves specific SDDC by name
                $sddcs = Get-VmcSddc -Name $SddcName
                Write-Host "Retrieved SDDC: $SddcName" -ForegroundColor Green
            }
        } else {
            # Retrieves all SDDCs
            $sddcs = Get-VmcSddc
            Write-Host "Found $($sddcs.Count) SDDCs" -ForegroundColor Green
        }
        
        foreach ($sddc in $sddcs) {
            Write-Host "  - $($sddc.Name): $($sddc.SddcState)" -ForegroundColor White
            Write-Host "    Region: $($sddc.ResourceConfig.Region)" -ForegroundColor Gray
            Write-Host "    Hosts: $($sddc.ResourceConfig.NumHosts)" -ForegroundColor Gray
        }
        
        return $sddcs
    }
    catch {
        Write-Error "Failed to retrieve SDDCs: $($_.Exception.Message)"
    }
}

# Example: Get VMC organizations
function Get-VmcOrganizations {
    try {
        $organizations = Get-VmcOrganization
        Write-Host "Found $($organizations.Count) organizations" -ForegroundColor Green
        
        foreach ($org in $organizations) {
            Write-Host "  - $($org.DisplayName): $($org.Id)" -ForegroundColor White
        }
        
        return $organizations
    }
    catch {
        Write-Error "Failed to retrieve organizations: $($_.Exception.Message)"
    }
}

# Example: Get VMC tasks
function Get-VmcTasks {
    param(
        [Parameter(Mandatory = $false)]
        [string]$OrganizationId
    )
    
    try {
        if ($OrganizationId) {
            $tasks = Get-VmcTask -Org $OrganizationId
            Write-Host "Found $($tasks.Count) tasks for organization: $OrganizationId" -ForegroundColor Green
        } else {
            $tasks = Get-VmcTask
            Write-Host "Found $($tasks.Count) total tasks" -ForegroundColor Green
        }
        
        foreach ($task in $tasks | Select-Object -First 10) {
            Write-Host "  - $($task.TaskType): $($task.Status)" -ForegroundColor White
            Write-Host "    Started: $($task.StartTime)" -ForegroundColor Gray
        }
        
        return $tasks
    }
    catch {
        Write-Error "Failed to retrieve tasks: $($_.Exception.Message)"
    }
}

# Example: Get VMC network segments
function Get-VmcNetworkSegments {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SddcId
    )
    
    try {
        $segments = Get-VmcNetworkSegment -Sddc $SddcId
        Write-Host "Found $($segments.Count) network segments in SDDC: $SddcId" -ForegroundColor Green
        
        foreach ($segment in $segments) {
            Write-Host "  - $($segment.DisplayName): $($segment.Subnets[0].Network)" -ForegroundColor White
        }
        
        return $segments
    }
    catch {
        Write-Error "Failed to retrieve network segments: $($_.Exception.Message)"
    }
}

# Example: Get current VMC connection info
function Get-VmcConnectionInfo {
    try {
        $vmcServers = Get-VmcServer
        if ($vmcServers.Count -gt 0) {
            Write-Host "✅ VMware Cloud on AWS connection is active" -ForegroundColor Green
            
            foreach ($server in $vmcServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $vmcServers
        } else {
            Write-Host "❌ No VMware Cloud on AWS connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Error "Failed to retrieve VMC connection info: $($_.Exception.Message)"
    }
}

# Example: Test VMC connection
function Test-VmcConnection {
    try {
        $vmcServers = Get-VmcServer
        if ($vmcServers.Count -gt 0 -and $vmcServers[0].IsConnected) {
            Write-Host "✅ VMware Cloud on AWS connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ VMware Cloud on AWS connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ VMC connection test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
