<#
.SYNOPSIS
    vRealize Operations Manager connection examples

.DESCRIPTION
    Demonstrates various methods to connect to vRealize Operations Manager servers

.NOTES
    Requires VMware PowerCLI 13.3.0 or later with vRealize Operations module
#>

# Example 1: Basic vROps connection with username and password
function Connect-OMServerBasic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerName,
        [Parameter(Mandatory = $true)]
        [string]$UserName,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects to VMware Aria Operations server using User and Password parameters
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-OMServer -Server $ServerName -User $UserName -Password $plainPassword
        Write-Host "Successfully connected to vRealize Operations server: $ServerName" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to vROps server $ServerName: $($_.Exception.Message)"
    }
}

# Example 2: vCenter Server authentication
function Connect-OMServerVCenterAuth {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerName,
        [Parameter(Mandatory = $true)]
        [string]$AuthSource,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Connects as vCenter Server user imported from monitored vCenter
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        Connect-OMServer -Server $ServerName -AuthSource $AuthSource -User $User -Password $plainPassword
        Write-Host "Successfully connected to vROps server using vCenter authentication: $ServerName" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to vROps server $ServerName with vCenter auth: $($_.Exception.Message)"
    }
}

# Example 3: Existing session connection
function Connect-OMServerSession {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerName,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    
    try {
        # Create initial connection and get session
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $srv = Connect-OMServer $ServerName -User $User -Password $plainPassword
        Write-Host "Initial connection established, SessionId: $($srv.SessionId)" -ForegroundColor Yellow
        
        # Connect using existing session
        Connect-OMServer $ServerName -Session $srv.SessionId
        Write-Host "Successfully connected to vROps server using existing session: $ServerName" -ForegroundColor Green
        
        return $srv
    }
    catch {
        Write-Error "Failed to connect to vROps server $ServerName with session: $($_.Exception.Message)"
    }
}

# Example 4: Credentials object connection
function Connect-OMServerCredential {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerName,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )
    
    try {
        if (-not $Credential) {
            # Create credential object interactively
            $Credential = Get-Credential -Message "Enter vRealize Operations credentials"
        }
        
        # Connects using credentials object
        Connect-OMServer $ServerName -Credential $Credential
        Write-Host "Successfully connected to vROps server using credential object: $ServerName" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to vROps server $ServerName: $($_.Exception.Message)"
    }
}

# Example: Get vROps alerts for a resource
function Get-OMResourceAlerts {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceName,
        [Parameter(Mandatory = $false)]
        [ValidateSet("Active", "Canceled", "All")]
        [string]$Status = "Active"
    )
    
    try {
        # Get the resource first
        $resource = Get-OMResource -Name $ResourceName
        if (-not $resource) {
            Write-Warning "Resource '$ResourceName' not found"
            return
        }
        
        # Retrieve alerts for the resource
        if ($Status -eq "All") {
            $alerts = Get-OMAlert -Resource $resource
        } else {
            $alerts = Get-OMAlert -Resource $resource -Status $Status
        }
        
        Write-Host "Found $($alerts.Count) $Status alerts for resource: $ResourceName" -ForegroundColor Green
        
        foreach ($alert in $alerts | Select-Object -First 10) {
            Write-Host "  - $($alert.AlertDefinitionName): $($alert.CriticalityLevel)" -ForegroundColor White
            Write-Host "    Status: $($alert.Status) | Created: $($alert.StartTimeUTC)" -ForegroundColor Gray
        }
        
        return $alerts
    }
    catch {
        Write-Error "Failed to retrieve alerts for resource $ResourceName: $($_.Exception.Message)"
    }
}

# Example: Get vROps resources
function Get-OMResources {
    param(
        [Parameter(Mandatory = $false)]
        [string]$ResourceKind,
        [Parameter(Mandatory = $false)]
        [string]$AdapterKind
    )
    
    try {
        if ($ResourceKind -and $AdapterKind) {
            $resources = Get-OMResource -ResourceKind $ResourceKind -AdapterKind $AdapterKind
            Write-Host "Found $($resources.Count) resources of kind '$ResourceKind' for adapter '$AdapterKind'" -ForegroundColor Green
        } elseif ($ResourceKind) {
            $resources = Get-OMResource -ResourceKind $ResourceKind
            Write-Host "Found $($resources.Count) resources of kind: $ResourceKind" -ForegroundColor Green
        } else {
            $resources = Get-OMResource
            Write-Host "Found $($resources.Count) total resources" -ForegroundColor Green
        }
        
        foreach ($resource in $resources | Select-Object -First 10) {
            Write-Host "  - $($resource.Name): $($resource.ResourceKindKey)" -ForegroundColor White
        }
        
        return $resources
    }
    catch {
        Write-Error "Failed to retrieve resources: $($_.Exception.Message)"
    }
}

# Example: Get vROps metrics for a resource
function Get-OMResourceMetrics {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ResourceName,
        [Parameter(Mandatory = $false)]
        [string[]]$MetricKeys,
        [Parameter(Mandatory = $false)]
        [int]$Hours = 24
    )
    
    try {
        # Get the resource
        $resource = Get-OMResource -Name $ResourceName
        if (-not $resource) {
            Write-Warning "Resource '$ResourceName' not found"
            return
        }
        
        # Calculate time range
        $endTime = Get-Date
        $startTime = $endTime.AddHours(-$Hours)
        
        if ($MetricKeys) {
            # Get specific metrics
            $metrics = Get-OMStat -Resource $resource -Key $MetricKeys -From $startTime -To $endTime
            Write-Host "Retrieved $($MetricKeys.Count) metrics for resource: $ResourceName" -ForegroundColor Green
        } else {
            # Get all available metrics
            $metrics = Get-OMStat -Resource $resource -From $startTime -To $endTime
            Write-Host "Retrieved all available metrics for resource: $ResourceName" -ForegroundColor Green
        }
        
        return $metrics
    }
    catch {
        Write-Error "Failed to retrieve metrics for resource $ResourceName: $($_.Exception.Message)"
    }
}

# Example: Get vROps adapter instances
function Get-OMAdapterInstances {
    param(
        [Parameter(Mandatory = $false)]
        [string]$AdapterKind
    )
    
    try {
        if ($AdapterKind) {
            $adapters = Get-OMAdapterInstance -AdapterKind $AdapterKind
            Write-Host "Found $($adapters.Count) adapter instances of kind: $AdapterKind" -ForegroundColor Green
        } else {
            $adapters = Get-OMAdapterInstance
            Write-Host "Found $($adapters.Count) total adapter instances" -ForegroundColor Green
        }
        
        foreach ($adapter in $adapters) {
            Write-Host "  - $($adapter.Name): $($adapter.AdapterKindKey)" -ForegroundColor White
            Write-Host "    Status: $($adapter.CollectionStatus)" -ForegroundColor Gray
        }
        
        return $adapters
    }
    catch {
        Write-Error "Failed to retrieve adapter instances: $($_.Exception.Message)"
    }
}

# Example: Get current vROps connection info
function Get-OMConnectionInfo {
    try {
        $omServers = Get-OMServer
        if ($omServers.Count -gt 0) {
            Write-Host "✅ vRealize Operations connection is active" -ForegroundColor Green
            
            foreach ($server in $omServers) {
                Write-Host "  - Server: $($server.Name)" -ForegroundColor White
                Write-Host "    User: $($server.User)" -ForegroundColor White
                Write-Host "    Version: $($server.Version)" -ForegroundColor White
                Write-Host "    Connected: $($server.IsConnected)" -ForegroundColor White
            }
            
            return $omServers
        } else {
            Write-Host "❌ No vRealize Operations connections found" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Error "Failed to retrieve vROps connection info: $($_.Exception.Message)"
    }
}

# Example: Test vROps connection
function Test-OMConnection {
    try {
        $omServers = Get-OMServer
        if ($omServers.Count -gt 0 -and $omServers[0].IsConnected) {
            Write-Host "✅ vRealize Operations connection is active" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ vRealize Operations connection is not active" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ vROps connection test failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}