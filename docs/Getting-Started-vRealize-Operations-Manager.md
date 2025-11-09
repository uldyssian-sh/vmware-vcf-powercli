# Getting Started with vRealize Operations Manager cmdlets

Provides cmdlets for automating vRealize Operations Manager features.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-OMServer` command. Run the code sample below to connect.

```powershell
# Connects to a VMware Aria Operations server by using the User and Password parameters.
Connect-OMServer -Server 'server_name' -User 'user_name' -Password 'user_password'
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: vCenter Server Authentication
```powershell
# Connects to a VMware Aria Operations server as a vCenter Server user, imported from the monitored vCenter Server system.
Connect-OMServer -Server 'server_name' -AuthSource 'vCenterServer_name_in_vROps' -User 'vCenterServer_admin' -Password 'user_password'
```

### Option 2: Existing Session
```powershell
# Connects to a VMware Aria Operations server with an existing session.
$srv = Connect-OMServer 'server_name' -User 'admin' -Password 'user_password'
Connect-OMServer 'server_name' -Session $srv.SessionId
```

### Option 3: Credentials Object
```powershell
# Connects to a vRealize Operations server by using a credentials object.
$secpasswd = ConvertTo-SecureString 'PlainTextPassword' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ('user_name', $secpasswd)
Connect-OMServer 'server_name' -Credential $mycreds
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-OMAlert` cmdlet. See example below:

```powershell
# Retrieves all active alerts for a given resource.
$resource = Get-OMResource -Name 'MyResource'
Get-OMAlert -Resource $resource -Status Active
```# Updated Sun Nov  9 12:50:15 CET 2025
