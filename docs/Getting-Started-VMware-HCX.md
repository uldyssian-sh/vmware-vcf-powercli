# Getting Started with VMware HCX cmdlets

Provides cmdlets for managing VMware HCX features.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-HCXServer` command. Run the code sample below to connect.

```powershell
# Connects to an HCX server by using the User and Password parameters.
Connect-HCXServer -Server $serverAddress -User $user -Password $pass
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Credential Parameter
```powershell
# Connects to an HCX server by using the Credential parameter.
$credential = Get-Credential
Connect-HCXServer -Server $serverAddress -Credential $credential
```

### Option 2: Save Credentials
```powershell
# Connects to an HCX server and stores the credentials in the credential store.
Connect-HCXServer -Server $serverAddress -Credential -User $user -Password $pass -SaveCredential
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-HCXAppliance` cmdlet. See example below:

```powershell
# Retrieves the available appliances of type Interconnect, WAN Optimization, and L2Concentrator.
Get-HCXAppliance
```# Updated Sun Nov  9 12:50:15 CET 2025
