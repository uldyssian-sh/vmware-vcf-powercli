# Getting Started with VMware Cloud Services cmdlets

Provides cmdlets for managing VMware Cloud Services.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-Vcs` command. Run the code sample below to connect.

```powershell
# Connects to a VMware Cloud Services server.
Connect-Vcs -ApiToken $apiToken
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Save API Token
```powershell
# Connects to a VMware Cloud Services server by specifying the related secure connection token and saving it for later use.
Connect-Vcs -ApiToken $script:apiToken -SaveApiToken
```

### Option 2: OAuth Security Context
```powershell
# Connects to a VMware Cloud Services server by specifying an OAuth security context. In this case, you can create it by using the API token.
$oauthSecurityContext = New-VcsOAuthSecurityContext -ApiToken $script:apiToken
Connect-Vcs -OAuthSecurityContext $oauthSecurityContext
```

### Option 3: Explicit Server Specification
```powershell
# Connects to a VMware Cloud Services server by explicitly specifying the host name of the VMware Cloud Services and the VMware Cloud Services server for the commercial instance. If you want to use a different instance, you can find the corresponding host names in the Developer Center section of the web portal.
$oauthSecurityContext = New-VcsOAuthSecurityContext -VcsServer "console.cloud.vmware.com" -ApiToken $script:apiToken
Connect-Vcs -Server "console.cloud.vmware.com" -OAuthSecurityContext $oauthSecurityContext
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-VcsOrganizationRole` cmdlet. See example below:

```powershell
# Retrieves the organization role with an "OrganizationRoleId" ID.
Get-VcsOrganizationRole -Id "OrganizationRoleId"
```