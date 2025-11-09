<#
.SYNOPSIS
    VMware vCloud Director connection examples

.DESCRIPTION
    Demonstrates various methods to connect to vCloud Director servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later
#>

# Example 1: Organization user connection
function Connect-CIServerOrganization {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )
    
    try {
        # Connects as an organization user to the provided organization
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-CIServer -Server $Server -User $User -Password $plainPassword -Org $Organization
        Write-Host "Successfully connected to $Server as organization user" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 2: System administrator connection
function Connect-CIServerSystemAdmin {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects as a system administrator to a system organization
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-CIServer -Server $Server -User $User -Password $plainPassword
        Write-Host "Successfully connected to $Server as system administrator" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 3: Credential object connection
function Connect-CIServerCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$Organization,
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )
    
    try {
        # Connects to the provided organization by specifying a credential object
        Connect-CIServer -Server $Server -Org $Organization -Credential $Credential
        Write-Host "Successfully connected to $Server using credential object" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 4: Session ID connection
function Connect-CIServerSession {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$SessionID
    )
    
    try {
        # Connects to a server by providing a server session ID
        Connect-CIServer -Server $Server -SessionID $SessionID
        Write-Host "Successfully connected to $Server using session ID" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server with session: $($_.Exception.Message)"
    }
}

# Example 5: Menu selection connection
function Connect-CIServerMenu {
    try {
        # Connects to a server from the list of recently connected servers
        Connect-CIServer -Menu
        Write-Host "Connected using menu selection" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect using menu: $($_.Exception.Message)"
    }
}

# Example 6: vCloud Air datacenter connection
function Connect-CIServerCloudAir {
    param(
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $true)]
        [string]$DatacenterName
    )
    
    try {
        # Connects to a vCloud Air datacenter
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $vCloudAirConnection = Connect-PIServer -User $User -Password $plainPassword
        $myDatacenter = Get-PIDatacenter $DatacenterName
        Connect-CIServer -PIDatacenter $myDatacenter
        Write-Host "Successfully connected to vCloud Air datacenter: $DatacenterName" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to vCloud Air datacenter $DatacenterName: $($_.Exception.Message)"
    }
}

# Example: Retrieve CIDatastore objects
function Get-vCloudDirectorDatastores {
    param(
        [Parameter(Mandatory = $false)]
        [string]$NamePattern = "*"
    )
    
    try {
        # Retrieves datastores with names matching the pattern
        $datastores = Get-CIDatastore -Name $NamePattern
        Write-Host "Found $($datastores.Count) datastores matching pattern: $NamePattern" -ForegroundColor Green
        
        return $datastores
    }
    catch {
        Write-Error "Failed to retrieve datastores: $($_.Exception.Message)"
    }
}

# Example: Get organization information
function Get-vCloudDirectorOrganizations {
    try {
        $organizations = Get-Org
        Write-Host "Found $($organizations.Count) organizations" -ForegroundColor Green
        
        foreach ($org in $organizations) {
            Write-Host "  - $($org.Name): $($org.Description)" -ForegroundColor White
        }
        
        return $organizations
    }
    catch {
        Write-Error "Failed to retrieve organizations: $($_.Exception.Message)"
    }
}

# Example: Get vApp information
function Get-vCloudDirectorvApps {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Organization
    )
    
    try {
        if ($Organization) {
            $vApps = Get-CIVApp -Org $Organization
            Write-Host "Found $($vApps.Count) vApps in organization: $Organization" -ForegroundColor Green
        } else {
            $vApps = Get-CIVApp
            Write-Host "Found $($vApps.Count) total vApps" -ForegroundColor Green
        }
        
        return $vApps
    }
    catch {
        Write-Error "Failed to retrieve vApps: $($_.Exception.Message)"
    }
}# Updated Sun Nov  9 12:52:11 CET 2025
