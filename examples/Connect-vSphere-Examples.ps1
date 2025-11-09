<#
.SYNOPSIS
    VMware vSphere connection examples for VCF environments

.DESCRIPTION
    Demonstrates various methods to connect to vSphere servers in VCF environment

.NOTES
    Requires VMware PowerCLI 13.3.0 or later
#>

# Example 1: Basic connection with credentials
function Connect-vSphereBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to a vSphere server by using the User and Password parameters
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VIServer -Server $Server -Protocol https -User $User -Password $plainPassword
        Write-Host "Successfully connected to $Server" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 2: Connection with credential object
function Connect-vSphereCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential,
        [Parameter(Mandatory = $false)]
        [int]$Port = 443
    )
    
    try {
        # Connects to a vSphere server by using a credential object
        Connect-VIServer $Server -Credential $Credential -Port $Port
        Write-Host "Successfully connected to $Server using credential object" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 3: Connection using session ID
function Connect-vSphereSession {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$SessionId
    )
    
    try {
        # Connects by using a server session ID
        Connect-VIServer $Server -Session $SessionId
        Write-Host "Successfully connected to $Server using session ID" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server with session: $($_.Exception.Message)"
    }
}

# Example 4: Integrated authentication
function Connect-vSphereIntegrated {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server
    )
    
    try {
        # Connects by using integrated authentication
        Connect-VIServer $Server
        Write-Host "Successfully connected to $Server using integrated authentication" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server with integrated auth: $($_.Exception.Message)"
    }
}

# Example 5: Save credentials in credential store
function Connect-vSphereSaveCredentials {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to a server and save the credentials in the credential store
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VIServer $Server -User $User -Password $plainPassword -SaveCredentials
        Write-Host "Successfully connected to $Server and saved credentials" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to $Server: $($_.Exception.Message)"
    }
}

# Example 6: Menu selection
function Connect-vSphereMenu {
    try {
        # Connects to a server by choosing from a list of previously connected servers
        Connect-VIServer -Menu
        Write-Host "Connected using menu selection" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect using menu: $($_.Exception.Message)"
    }
}

# Example 7: Federation vCenter connection
function Connect-vSphereFederation {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential
    )
    
    try {
        # Connects to all vSphere servers in the federation
        Connect-VIServer $Server -Credential $Credential -AllLinked
        Write-Host "Successfully connected to federation vCenter: $Server" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to federation vCenter $Server: $($_.Exception.Message)"
    }
}

# Example 8: VMware Cloud Services connection
function Connect-vSphereCloudServices {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )
    
    try {
        # Connects using VMware Cloud Services API token
        $oauthCtx = New-VcsOAuthSecurityContext -ApiToken $ApiToken
        $samlCtx = New-VISamlSecurityContext -VCenterServer $Server -OAuthSecurityContext $oauthCtx
        Connect-VIServer -Server $Server -SamlSecurityContext $samlCtx
        Write-Host "Successfully connected to VMware Cloud Services vCenter: $Server" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to VMware Cloud Services vCenter $Server: $($_.Exception.Message)"
    }
}

# Example: Retrieve VMHost objects
function Get-vSphereHosts {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Datacenter
    )
    
    try {
        if ($Datacenter) {
            # Retrieves all hosts in the specified datacenter
            $hosts = Get-VMHost -Location $Datacenter
            Write-Host "Found $($hosts.Count) hosts in datacenter: $Datacenter" -ForegroundColor Green
        } else {
            # Retrieves all hosts
            $hosts = Get-VMHost
            Write-Host "Found $($hosts.Count) total hosts" -ForegroundColor Green
        }
        
        return $hosts
    }
    catch {
        Write-Error "Failed to retrieve hosts: $($_.Exception.Message)"
    }
}# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692693
