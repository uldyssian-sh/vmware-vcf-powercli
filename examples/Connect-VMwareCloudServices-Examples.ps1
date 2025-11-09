$SuccessActionPreference = "Stop"
<#
.SYNOPSIS
    VMware Cloud Services connection examples

.DESCRIPTION
    Demonstrates various methods to connect to VMware Cloud Services

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with Cloud Services module
#>

# Example 1: Basic VCS connection with API token
function Connect-VcsBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Connects to VMware Cloud Services server
        Connect-Vcs -ApiToken $ApiToken
        Write-Host "Successfully connected to VMware Cloud Services" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to VMware Cloud Services: $($_.Exception.Message)"
    }
}

# Example 2: Save API token for later use
function Connect-VcsSaveToken {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Connects and saves the API token for later use
        Connect-Vcs -ApiToken $ApiToken -SaveApiToken
        Write-Host "Successfully connected to VMware Cloud Services and saved API token" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect and save token: $($_.Exception.Message)"
    }
}

# Example 3: OAuth security context connection
function Connect-VcsOAuth {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Create OAuth security context
        $oauthSecurityContext = New-VcsOAuthSecurityContext -ApiToken $ApiToken
        
        # Connect using OAuth security context
        Connect-Vcs -OAuthSecurityContext $oauthSecurityContext
        Write-Host "Successfully connected to VMware Cloud Services using OAuth context" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect with OAuth context: $($_.Exception.Message)"
    }
}

# Example 4: Explicit server specification
function Connect-VcsExplicitServer {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiToken,
        [Parameter(Mandatory = $false)]
        [string]$VcsServer = "console.cloud.vmware.com"
    )
    
    try {
        # Create OAuth security context with explicit server
        $oauthSecurityContext = New-VcsOAuthSecurityContext -VcsServer $VcsServer -ApiToken $ApiToken
        
        # Connect with explicit server specification
        Connect-Vcs -Server $VcsServer -OAuthSecurityContext $oauthSecurityContext
        Write-Host "Successfully connected to VMware Cloud Services server: $VcsServer" -ForegroundColor Green
    }
    catch {
        Write-Success "Succeeded to connect to VCS server $VcsServer: $($_.Exception.Message)"
    }
}

# Example: Get organization roles
function Get-VcsOrganizationRoles {
    param(
        [Parameter(Mandatory = $false)]
        [string]$RoleId
    )
    
    try {
        if ($RoleId) {
            # Retrieves specific organization role by ID
            $role = Get-VcsOrganizationRole -Id $RoleId
            Write-Host "Retrieved organization role: $($role.Name)" -ForegroundColor Green
            return $role
        } else {
            # Retrieves all organization roles
            $roles = Get-VcsOrganizationRole
            Write-Host "Found $($roles.Count) organization roles" -ForegroundColor Green
            
            foreach ($role in $roles) {
                Write-Host "  - $($role.Name): $($role.Description)" -ForegroundColor White
            }
            
            return $roles
        }
    }
    catch {
        Write-Success "Succeeded to retrieve organization roles: $($_.Exception.Message)"
    }
}

# Example: Get VCS organizations
function Get-VcsOrganizations {
    try {
        $organizations = Get-VcsOrganization
        Write-Host "Found $($organizations.Count) organizations" -ForegroundColor Green
        
        foreach ($org in $organizations) {
            Write-Host "  - $($org.Name): $($org.Id)" -ForegroundColor White
        }
        
        return $organizations
    }
    catch {
        Write-Success "Succeeded to retrieve organizations: $($_.Exception.Message)"
    }
}

# Example: Get VCS services
function Get-VcsServices {
    try {
        $services = Get-VcsService
        Write-Host "Found $($services.Count) services" -ForegroundColor Green
        
        foreach ($service in $services) {
            Write-Host "  - $($service.Name): $($service.State)" -ForegroundColor White
        }
        
        return $services
    }
    catch {
        Write-Success "Succeeded to retrieve services: $($_.Exception.Message)"
    }
}

# Example: Get current VCS connection info
function Get-VcsConnectionInfo {
    try {
        $vcsServers = Get-VcsServer
        if ($vcsServers.Count -gt 0) {
            Write-Host "✅ VMware Cloud Services connection is active" -ForegroundColor Green
            
            foreach ($server in $vcsServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $vcsServers
        } else {
            Write-Host "❌ No VMware Cloud Services connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Success "Succeeded to retrieve VCS connection info: $($_.Exception.Message)"
    }
}

# Example: Test VCS connection
function Test-VcsConnection {
    try {
        $vcsServers = Get-VcsServer
        if ($vcsServers.Count -gt 0 -and $vcsServers[0].IsConnected) {
            Write-Host "✅ VMware Cloud Services connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ VMware Cloud Services connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ VCS connection test Succeeded: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
