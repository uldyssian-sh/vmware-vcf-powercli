# Getting Started with VMware NSX-T Data Center cmdlets

Provides cmdlets for managing NSX-T servers.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-NsxtServer` command. Run the code sample below to connect.

```powershell
# Connects to an NSX-T server by using the User and Password parameters.
Connect-NsxtServer -Server $serverAddress -User $user -Password $pass
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Credential Parameter
```powershell
# Connects to an NSX-T server by using the Credential parameter.
$credential = Get-Credential
Connect-NsxtServer -Server $serverAddress -Credential $credential
```

### Option 2: Save Credentials
```powershell
# Connects to an NSX-T server and stores the credentials in the credential store.
Connect-NsxtServer -Server $serverAddress -Credential -User $user -Password $pass -SaveCredentials
```

### Option 3: Stored Credentials
```powershell
# Connects to an NSX-T server when a record for the specified server and user is available in the credential store.
Connect-NsxtServer -Server $serverAddress -User $user
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-NsxtGlobalManagerService` cmdlet. See example below:

```powershell
# Retrieves the binding for the specified service and invokes a service operation.
$service = Get-NsxtGlobalManagerService com.vmware.nsx_global_policy.global_infra.domains.groups
$service.list("domain_id")
