# Getting Started with VMware Cloud On AWS cmdlets

Provides cmdlets for managing VMware Cloud on AWS features.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-Vmc` command. Run the code sample below to connect.

```powershell
# Connects to a VMware Cloud on AWS server.
Connect-Vmc -ApiToken $apiToken
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Save API Token
```powershell
# Connects to a VMware Cloud on AWS server by specifying the related secure connection token and saving it for later usage.
Connect-Vmc -ApiToken $script:apiToken -SaveApiToken
```

### Option 2: OAuth Security Context
```powershell
# Connects to a VMware Cloud on AWS server by specifying an OAuth security context. In this case, you can create it by using the API token.
$oauthSecurityContext = New-VcsOAuthSecurityContext -ApiToken $script:apiToken
Connect-Vmc -OAuthSecurityContext $oauthSecurityContext
```

### Option 3: Explicit Server Specification
```powershell
# Connects to a VMware Cloud on AWS server by explicitly specifying the host name of the VMware Cloud Services and the VMware Cloud on AWS server for the commercial instance. If you want to use a different instance, you can find the corresponding host names in the Developer Center section of the web portal.
$oauthSecurityContext = New-VcsOAuthSecurityContext -VcsServer "console.cloud.vmware.com" -ApiToken $script:apiToken
Connect-Vmc -Server "vmc.vmware.com" -OAuthSecurityContext $oauthSecurityContext
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-VmcSddc` cmdlet. See example below:

```powershell
# Retrieves the deleted and non-deleted SDDCs named "SddcName".
Get-VmcSddc -Name "SddcName" -IncludeDeleted
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692692
