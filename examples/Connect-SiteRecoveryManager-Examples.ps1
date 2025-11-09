<#
.SYNOPSIS
    VMware Site Recovery Manager connection examples

.DESCRIPTION
    Demonstrates various methods to connect to Site Recovery Manager servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with SRM module
#>

# Example 1: Basic SRM connection via vCenter
function Connect-SrmServerBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$VCenterServer,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connect to vCenter Server first
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VIServer $VCenterServer -User $User -Password $plainPassword
        Write-Host "Connected to vCenter Server: $VCenterServer" -ForegroundColor Green
        
        # Connect to associated SRM server
        Connect-SrmServer
        Write-Host "Successfully connected to SRM server via vCenter" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to SRM via vCenter $VCenterServer: $($_.Exception.Message)"
    }
}

# Example 2: Direct SRM server connection
function Connect-SrmServerDirect {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SrmServerAddress,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects directly to SRM server by IP address
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-SrmServer -SrmServerAddress $SrmServerAddress -User $User -Password $plainPassword
        Write-Host "Successfully connected to SRM server: $SrmServerAddress" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to SRM server $SrmServerAddress: $($_.Exception.Message)"
    }
}

# Example 3: Remote credential connection
function Connect-SrmServerRemoteCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$VCenterServer,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [Parameter(Mandatory = $true)]
        [PSCredential]$RemoteCredential
    )
    
    try {
        # Connect to vCenter Server first
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VIServer $VCenterServer -User $User -Password $plainPassword
        Write-Host "Connected to vCenter Server: $VCenterServer" -ForegroundColor Green
        
        # Connect to SRM server with remote credentials
        Connect-SrmServer -RemoteCredential $RemoteCredential
        Write-Host "Successfully connected to SRM server with remote credentials" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to SRM with remote credentials: $($_.Exception.Message)"
    }
}

# Example 4: Ignore certificate errors connection
function Connect-SrmServerIgnoreCerts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$VCenterServer,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connect to vCenter Server first
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-VIServer $VCenterServer -User $User -Password $plainPassword
        Write-Host "Connected to vCenter Server: $VCenterServer" -ForegroundColor Green
        
        # Connect to SRM server ignoring certificate errors
        Connect-SrmServer -NotDefault -IgnoreCertificateErrors
        Write-Host "Successfully connected to SRM server (ignoring certificate errors)" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to SRM server: $($_.Exception.Message)"
    }
}

# Example: Get SRM protection groups
function Get-SrmProtectionGroups {
    try {
        $protectionGroups = Get-SrmProtectionGroup
        Write-Host "Found $($protectionGroups.Count) protection groups" -ForegroundColor Green
        
        foreach ($pg in $protectionGroups) {
            Write-Host "  - $($pg.Name): $($pg.State)" -ForegroundColor White
        }
        
        return $protectionGroups
    }
    catch {
        Write-Error "Failed to retrieve protection groups: $($_.Exception.Message)"
    }
}

# Example: Get SRM recovery plans
function Get-SrmRecoveryPlans {
    try {
        $recoveryPlans = Get-SrmRecoveryPlan
        Write-Host "Found $($recoveryPlans.Count) recovery plans" -ForegroundColor Green
        
        foreach ($rp in $recoveryPlans) {
            Write-Host "  - $($rp.Name): $($rp.State)" -ForegroundColor White
        }
        
        return $recoveryPlans
    }
    catch {
        Write-Error "Failed to retrieve recovery plans: $($_.Exception.Message)"
    }
}

# Example: Get SRM server information
function Get-SrmServerInfo {
    try {
        $srmServers = Get-SrmServer
        Write-Host "Connected SRM Servers:" -ForegroundColor Green
        
        foreach ($server in $srmServers) {
            Write-Host "  - Name: $($server.Name)" -ForegroundColor White
            Write-Host "    Version: $($server.Version)" -ForegroundColor White
            Write-Host "    Build: $($server.Build)" -ForegroundColor White
        }
        
        return $srmServers
    }
    catch {
        Write-Error "Failed to retrieve SRM server information: $($_.Exception.Message)"
    }
}

# Example: Test SRM connection
function Test-SrmConnection {
    try {
        $srmServers = Get-SrmServer
        if ($srmServers.Count -gt 0) {
            Write-Host "✅ SRM connection is active" -ForegroundColor Green
            Write-Host "Connected to $($srmServers.Count) SRM server(s)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ No SRM connections found" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ SRM connection test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
