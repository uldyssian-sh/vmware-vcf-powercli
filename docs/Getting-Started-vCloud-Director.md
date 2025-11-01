# Getting Started with VMware Cloud Director cmdlets

Provides cmdlets for automating vCloud Director features.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-CIServer` command. Run the code sample below to connect.

```powershell
# Connects as an organization user to the provided organization.
Connect-CIServer -Server cloud.example.com -User Org1Admin -Password pass -Org Organization1
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: System Administrator
```powershell
# Connects as a system administrator to a system organization.
Connect-CIServer -Server cloud.example.com -User admin -Password pass
```

### Option 2: Credential Object
```powershell
# Connects to the provided organization by specifying a credential object.
Connect-CIServer -Server cloud.example.com -Org Organization1 -Credential $vappUserCredential
```

### Option 3: Session ID
```powershell
# Connects to a server by providing a server session ID.
Connect-CIServer -Server cloud.example.com -SessionID $sessionID
```

### Option 4: Menu Selection
```powershell
# Connects to a server from the list of recently connected servers.
Connect-CIServer -Menu
```

### Option 5: vCloud Air Datacenter
```powershell
# Connects to a vCloud Air datacenter.
$vCloudAirConnection = Connect-PIServer -User myUser@vmware.com -Password 'pass'
$myDatacenter = Get-PIDatacenter 'myDatacenter'
Connect-CIServer -PIDatacenter $myDatacenter
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-CIDatastore` cmdlet. See example below:

```powershell
# Retrieves all datastores with names that start with "MyDatastore" from all available provider vDCs.
Get-CIDatastore -Name "MyDatastore*"
```