# Getting Started with VMware vSphere And vSAN cmdlets

Provides cmdlets for automated administration of the vSphere environment.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-VIServer` command. Run the code sample below to connect.

```powershell
# Connects to a vSphere server by using the User and Password parameters.
Connect-VIServer -Server 10.23.112.235 -Protocol https -User admin -Password pass
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Credential Object
```powershell
# Connects to a vSphere server by using a credential object.
Connect-VIServer Server -Credential $myCredentialsObject -Port 1234
```

### Option 2: Session ID
```powershell
# Connects by using a server session ID. Once you connect to a server, you can save the session ID - $serverObject.SessionId, so that you can restore the existing server connection instead of reconnecting.
Connect-VIServer "Server" -Session $sessionId
```

### Option 3: Integrated Authentication
```powershell
# Connects by using integrated authentication. In this case, the credentials you are logged on to your machine must be the same as those for the server.
Connect-VIServer Server
```

### Option 4: Save Credentials
```powershell
# Connects to a server and save the credentials in the credential store. After the credentials are stored, you can connect to the server without specifying them. To get a previously saved credential store item, use the Get-VICredentialStoreItem cmdlet.
Connect-VIServer "Server" -User user -Password pass -SaveCredentials
```

### Option 5: Menu Selection
```powershell
# Connects to a server by choosing the server address from a list of previously connected servers.
Connect-VIServer -Menu
```

### Option 6: Federation vCenter
```powershell
# Connects to a vSphere server which is a part of a federation vCenter Server system. This will connect you to all vSphere servers in the federation as well.
Connect-VIServer "Server" -AllLinked
```

### Option 7: VMware Cloud Services
```powershell
# Connects to a vCenter server that runs in a VMware managed cloud using an API token from the VMware Cloud Services portal.
$oauthCtx = New-VcsOAuthSecurityContext -ApiToken "a3f35067-80b5-44f0-a0bc-e19f2bc17fb7"
$samlCtx = New-VISamlSecurityContext -VCenterServer "Server" -OAuthSecurityContext $oauthCtx
Connect-VIServer -Server "Server" -SamlSecurityContext $samlCtx
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-VMHost` cmdlet. See example below:

```powershell
# Retrieves all hosts in the specified datacenter.
Get-VMHost -Location MyDatacenter
