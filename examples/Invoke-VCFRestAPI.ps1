<#
.SYNOPSIS
    Invoke VMware Cloud Foundation REST API calls

.DESCRIPTION
    Demonstrates how to make direct REST API calls to VCF SDDC Manager

.PARAMETER FQDN
    FQDN of SDDC Manager

.PARAMETER Credential
    PSCredential object for authentication

.PARAMETER Endpoint
    API endpoint to call (e.g., "/v1/domains")

.PARAMETER Method
    HTTP method (GET, POST, PUT, DELETE)

.EXAMPLE
    Invoke-VCFRestAPI -FQDN "vcf-mgmt01.domain.local" -Credential $cred -Endpoint "/v1/domains"

.NOTES
    Requires PowerShell 7.2+ for proper REST API support
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$FQDN,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]$Credential,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Endpoint,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("GET", "POST", "PUT", "DELETE")]
    [string]$Method = "GET"
)

try {
    # Disable certificate validation for self-signed certificates
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $PSDefaultParameterValues['Invoke-RestMethod:SkipCertificateCheck'] = $true
        $PSDefaultParameterValues['Invoke-WebRequest:SkipCertificateCheck'] = $true
    } else {
        # PowerShell 5.1 compatibility
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    }
    
    # Step 1: Authenticate and get access token
    Write-Host "Authenticating to SDDC Manager..." -ForegroundColor Yellow
    
    $authUrl = "https://$FQDN/v1/tokens"
    $authBody = @{
        username = $Credential.UserName
        password = $Credential.GetNetworkCredential().Password
    } | ConvertTo-Json
    
    $authHeaders = @{
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }
    
    $authResponse = Invoke-RestMethod -Uri $authUrl -Method POST -Body $authBody -Headers $authHeaders
    $accessToken = $authResponse.accessToken
    
    Write-Host "Authentication successful" -ForegroundColor Green
    
    # Step 2: Make API call with access token
    Write-Host "Making API call to: $Method $Endpoint" -ForegroundColor Yellow
    
    $apiUrl = "https://$FQDN$Endpoint"
    $apiHeaders = @{
        'Authorization' = "Bearer $accessToken"
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }
    
    $response = Invoke-RestMethod -Uri $apiUrl -Method $Method -Headers $apiHeaders
    
    Write-Host "API call successful" -ForegroundColor Green
    Write-Host ""
    
    # Display response
    if ($response) {
        Write-Host "Response:" -ForegroundColor Cyan
        $response | ConvertTo-Json -Depth 10 | Write-Host
    }
    
    return $response
}
catch {
    $errorDetails = $_.Exception.Message
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        $statusDescription = $_.Exception.Response.StatusDescription
        Write-Error "API call failed: $statusCode $statusDescription - $errorDetails"
    } else {
        Write-Error "API call failed: $errorDetails"
    }
    throw
}
finally {
    # Clean up parameter defaults
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $PSDefaultParameterValues.Remove('Invoke-RestMethod:SkipCertificateCheck')
        $PSDefaultParameterValues.Remove('Invoke-WebRequest:SkipCertificateCheck')
    }
}