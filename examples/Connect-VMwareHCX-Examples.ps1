<#
.SYNOPSIS
    VMware HCX connection examples

.DESCRIPTION
    Demonstrates various methods to connect to VMware HCX servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with HCX module
#>

# Example 1: Basic HCX connection with username and password
function Connect-HCXServerBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to HCX server using User and Password parameters
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-HCXServer -Server $ServerAddress -User $User -Password $plainPassword
        Write-Host "Successfully connected to HCX server: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to HCX server $ServerAddress: $($_.Exception.Message)"
    }
}

# Example 2: HCX connection with credential object
function Connect-HCXServerCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerAddress,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )
    
    try {
        if (-not $Credential) {
            # Get credentials interactively
            $Credential = Get-Credential -Message "Enter HCX credentials"
        }
        
        # Connects to HCX server using Credential parameter
        Connect-HCXServer -Server $ServerAddress -Credential $Credential
        Write-Host "Successfully connected to HCX server using credential object: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to HCX server $ServerAddress: $($_.Exception.Message)"
    }
}

# Example 3: Save credentials in credential store
function Connect-HCXServerSaveCredentials {
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
        Connect-HCXServer -Server $ServerAddress -User $User -Password $plainPassword -SaveCredential
        Write-Host "Successfully connected to HCX server and saved credentials: $ServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect and save credentials for $ServerAddress: $($_.Exception.Message)"
    }
}

# Example: Get HCX appliances
function Get-HCXAppliances {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("Interconnect", "WAN Optimization", "L2Concentrator", "All")]
        [string]$ApplianceType = "All"
    )
    
    try {
        # Retrieves available appliances
        $appliances = Get-HCXAppliance
        
        if ($ApplianceType -ne "All") {
            $appliances = $appliances | Where-Object { $_.Type -eq $ApplianceType }
            Write-Host "Found $($appliances.Count) $ApplianceType appliances" -ForegroundColor Green
        } else {
            Write-Host "Found $($appliances.Count) total HCX appliances" -ForegroundColor Green
        }
        
        foreach ($appliance in $appliances) {
            Write-Host "  - $($appliance.Name): $($appliance.Type)" -ForegroundColor White
            Write-Host "    Status: $($appliance.Status) | Version: $($appliance.Version)" -ForegroundColor Gray
        }
        
        return $appliances
    }
    catch {
        Write-Error "Failed to retrieve HCX appliances: $($_.Exception.Message)"
    }
}

# Example: Get HCX migrations
function Get-HCXMigrations {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("InProgress", "Completed", "Failed", "All")]
        [string]$Status = "All"
    )
    
    try {
        $migrations = Get-HCXMigration
        
        if ($Status -ne "All") {
            $migrations = $migrations | Where-Object { $_.Status -eq $Status }
            Write-Host "Found $($migrations.Count) migrations with status: $Status" -ForegroundColor Green
        } else {
            Write-Host "Found $($migrations.Count) total migrations" -ForegroundColor Green
        }
        
        foreach ($migration in $migrations | Select-Object -First 10) {
            Write-Host "  - $($migration.VMName): $($migration.Status)" -ForegroundColor White
            Write-Host "    Type: $($migration.MigrationType) | Progress: $($migration.Progress)%" -ForegroundColor Gray
        }
        
        return $migrations
    }
    catch {
        Write-Error "Failed to retrieve HCX migrations: $($_.Exception.Message)"
    }
}

# Example: Get HCX service mesh
function Get-HCXServiceMesh {
    try {
        $serviceMeshes = Get-HCXServiceMesh
        Write-Host "Found $($serviceMeshes.Count) service meshes" -ForegroundColor Green
        
        foreach ($mesh in $serviceMeshes) {
            Write-Host "  - $($mesh.Name): $($mesh.Status)" -ForegroundColor White
            Write-Host "    Source: $($mesh.SourceSite) | Destination: $($mesh.DestinationSite)" -ForegroundColor Gray
        }
        
        return $serviceMeshes
    }
    catch {
        Write-Error "Failed to retrieve HCX service meshes: $($_.Exception.Message)"
    }
}

# Example: Get HCX network extensions
function Get-HCXNetworkExtensions {
    try {
        $networkExtensions = Get-HCXNetworkExtension
        Write-Host "Found $($networkExtensions.Count) network extensions" -ForegroundColor Green
        
        foreach ($extension in $networkExtensions) {
            Write-Host "  - $($extension.NetworkName): $($extension.Status)" -ForegroundColor White
            Write-Host "    VLAN: $($extension.VLAN) | Gateway: $($extension.Gateway)" -ForegroundColor Gray
        }
        
        return $networkExtensions
    }
    catch {
        Write-Error "Failed to retrieve HCX network extensions: $($_.Exception.Message)"
    }
}

# Example: Get HCX sites
function Get-HCXSites {
    try {
        $sites = Get-HCXSite
        Write-Host "Found $($sites.Count) HCX sites" -ForegroundColor Green
        
        foreach ($site in $sites) {
            Write-Host "  - $($site.Name): $($site.Type)" -ForegroundColor White
            Write-Host "    Status: $($site.Status) | Version: $($site.Version)" -ForegroundColor Gray
        }
        
        return $sites
    }
    catch {
        Write-Error "Failed to retrieve HCX sites: $($_.Exception.Message)"
    }
}

# Example: Get HCX replication status
function Get-HCXReplicationStatus {
    param(
        [Parameter(Mandatory = $false)]
        [string]$VMName
    )
    
    try {
        if ($VMName) {
            $replications = Get-HCXReplication -VM $VMName
            Write-Host "Found replication status for VM: $VMName" -ForegroundColor Green
        } else {
            $replications = Get-HCXReplication
            Write-Host "Found $($replications.Count) active replications" -ForegroundColor Green
        }
        
        foreach ($replication in $replications) {
            Write-Host "  - $($replication.VMName): $($replication.Status)" -ForegroundColor White
            Write-Host "    Progress: $($replication.Progress)% | RPO: $($replication.RPO)" -ForegroundColor Gray
        }
        
        return $replications
    }
    catch {
        Write-Error "Failed to retrieve HCX replication status: $($_.Exception.Message)"
    }
}

# Example: Get current HCX connection info
function Get-HCXConnectionInfo {
    try {
        $hcxServers = Get-HCXServer
        if ($hcxServers.Count -gt 0) {
            Write-Host "✅ HCX connection is active" -ForegroundColor Green
            
            foreach ($server in $hcxServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Version: $($server.Version)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $hcxServers
        } else {
            Write-Host "❌ No HCX connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Error "Failed to retrieve HCX connection info: $($_.Exception.Message)"
    }
}

# Example: Test HCX connection
function Test-HCXConnection {
    try {
        $hcxServers = Get-HCXServer
        if ($hcxServers.Count -gt 0 -and $hcxServers[0].IsConnected) {
            Write-Host "✅ HCX connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ HCX connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ HCX connection test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}