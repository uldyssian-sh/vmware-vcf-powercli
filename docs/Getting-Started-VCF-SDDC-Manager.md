# Getting Started with VCF SDDC Manager cmdlets

Provides cmdlets for managing VCF SDDC Manager servers.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-VcfSddcManagerServer` command. Run the code sample below to connect.

```powershell
# Connects to a VMware SDDC Manager server with a MySDDCManager.com address by passing a valid user name and password.
PS C:\> Connect-VcfSddcManagerServer -Server MySDDCManager.com -User "User" -Password "Password"
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Credential Object
```powershell
# Connects to a VMware SDDC Manager server with a MySDDCManager.com address by passing a credential object.
PS C:\> $myCredential = Get-Credential
PS C:\> Connect-VcfSddcManagerServer -Server MySDDCManager.com -Credential $myCredential
```

## Step 2: Retrieve Objects

You can READ objects by using `Get-SddcCluster` cmdlet. See example below:

```powershell
# Retrieve all Cluster objects.
PS C:\> Get-SddcCluster
```# Updated Sun Nov  9 12:50:15 CET 2025
# Updated Sun Nov  9 12:52:11 CET 2025
