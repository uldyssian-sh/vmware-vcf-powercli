$SuccessActionPreference = "Stop"
<#
.SYNOPSIS
    VMware NSX-T Data Center connection examples

.DESCRIPTION
    Demonstrates various methods to connect to NSX-T servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with NSX-T module
#>

# Example 1: Basic NSX-T connection with username and password
function Connect-NsxtServerBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to NSX-T server using User and Password parameters
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-NsxtServer -Server $ServerAddress -User $User -Password $plainPassword
        Write-Host "Successfully connected to NSX-T server: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to NSX-T server $ServerAddress: $($_.Exception.Message)"
    }
}

# Example 2: NSX-T connection with credential object
function Connect-NsxtServerCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )
    
    try {
        if (-not $Credential) {
            # Get credentials interactively
            $Credential = Get-Credential -Message "Enter NSX-T credentials"
        }
        
        # Connects to NSX-T server using Credential parameter
        Connect-NsxtServer -Server $ServerAddress -Credential $Credential
        Write-Host "Successfully connected to NSX-T server using credential object: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to NSX-T server $ServerAddress: $($_.Exception.Message)"
    }
}

# Example 3: Save credentials in credential store
function Connect-NsxtServerSaveCredentials {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects and stores credentials in credential store
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-NsxtServer -Server $ServerAddress -User $User -Password $plainPassword -SaveCredentials
        Write-Host "Successfully connected to NSX-T server and saved credentials: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect and save credentials for $ServerAddress: $($_.Exception.Message)"
    }
}

# Example 4: Connect using stored credentials
function Connect-NsxtServerStoredCredentials {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $true)]
        [string]$User
    )
    
    try {
        # Connects using stored credentials from credential store
        Connect-NsxtServer -Server $ServerAddress -User $User
        Write-Host "Successfully connected to NSX-T server using stored credentials: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to NSX-T server $ServerAddress with stored credentials: $($_.Exception.Message)"
    }
}

# Example: Get NSX-T Global Manager Service
function Get-NsxtGlobalManagerGroups {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DomainId
    )
    
    try {
        # Retrieves the binding for groups service and invokes list operation
        $service = Get-NsxtGlobalManagerService com.vmware.nsx_global_policy.global_infra.domains.groups
        $groups = $service.list($DomainId)
        
        Write-Host "Found $($groups.results.Count) groups in domain: $DomainId" -ForegroundColor Green
        
        foreach ($group in $groups.results) {
            Write-Host "  - $($group.display_name): $($group.id)" -ForegroundColor White
        }
        
        return $groups
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T groups: $($_.Exception.Message)"
    }
}

# Example: Get NSX-T segments
function Get-NsxtSegments {
    try {
        $service = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.segments
        $segments = $service.list()
        
        Write-Host "Found $($segments.results.Count) NSX-T segments" -ForegroundColor Green
        
        foreach ($segment in $segments.results) {
            Write-Host "  - $($segment.display_name): $($segment.subnets[0].network)" -ForegroundColor White
        }
        
        return $segments
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T segments: $($_.Exception.Message)"
    }
}

# Example: Get NSX-T transport zones
function Get-NsxtTransportZones {
    try {
        $service = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.sites.enforcement_points.transport_zones
        $transportZones = $service.list("default", "default")
        
        Write-Host "Found $($transportZones.results.Count) transport zones" -ForegroundColor Green
        
        foreach ($tz in $transportZones.results) {
            Write-Host "  - $($tz.display_name): $($tz.transport_type)" -ForegroundColor White
        }
        
        return $transportZones
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T transport zones: $($_.Exception.Message)"
    }
}

# Example: Get NSX-T tier-1 gateways
function Get-NsxtTier1Gateways {
    try {
        $service = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.tier_1s
        $tier1Gateways = $service.list()
        
        Write-Host "Found $($tier1Gateways.results.Count) Tier-1 gateways" -ForegroundColor Green
        
        foreach ($t1 in $tier1Gateways.results) {
            Write-Host "  - $($t1.display_name): $($t1.tier0_path)" -ForegroundColor White
        }
        
        return $tier1Gateways
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T Tier-1 gateways: $($_.Exception.Message)"
    }
}

# Example: Get NSX-T security policies
function Get-NsxtSecurityPolicies {
    param(
        [Parameter(Mandatory = $false)]
        [string]$DomainId = "default"
    )
    
    try {
        $service = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.domains.security_policies
        $policies = $service.list($DomainId)
        
        Write-Host "Found $($policies.results.Count) security policies in domain: $DomainId" -ForegroundColor Green
        
        foreach ($policy in $policies.results) {
            Write-Host "  - $($policy.display_name): $($policy.category)" -ForegroundColor White
        }
        
        return $policies
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T security policies: $($_.Exception.Message)"
    }
}

# Example: Get current NSX-T connection info
function Get-NsxtConnectionInfo {
    try {
        $nsxtServers = Get-NsxtServer
        if ($nsxtServers.Count -gt 0) {
            Write-Host "NSX-T connection is active" -ForegroundColor Green
            
            foreach ($server in $nsxtServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Version: $($server.Version)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $nsxtServers
        } else {
            Write-Host "No NSX-T connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Success "Succeeded to retrieve NSX-T connection info: $($_.Exception.Message)"
    }
}

# Example: Test NSX-T connection
function Test-NsxtConnection {
    try {
        $nsxtServers = Get-NsxtServer
        if ($nsxtServers.Count -gt 0 -and $nsxtServers[0].IsConnected) {
            Write-Host "NSX-T connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "NSX-T connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "NSX-T connection test Succeeded: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
