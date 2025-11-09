# Getting Started with VMware Site Recovery Manager cmdlets

Provides cmdlets for managing VMware Site Recovery Manager features.

## Step 1: Connect to Environment

To setup a connection you should use the `Connect-SrmServer` command. Run the code sample below to connect.

```powershell
# Connects to a vCenter Server system, that has an SRM server associated with it. Then, invokes the cmdlet without specifying any parameters to establish a connection to the SRM server registered with the connected vCenter Server system. If you have previously connected to other vCenter Server systems configured with SRM server support, this cmdlet invocation will establish a connection to their corresponding SRM servers as well.
Connect-VIServer "myVCServerIp" -User "myUser" -Password "myPassword"
Connect-SrmServer
```

You can also connect to remote environment by running one of the alternative options to connect below:

### Option 1: Direct SRM Server Connection
```powershell
# Connects to an SRM server with an IP address of 192.0.2.1 by passing a valid user name and password.
Connect-SrmServer -SrmServerAddress 192.0.2.1 -User "myUser" -Password "myPassword"
```

### Option 2: Remote Credential Connection
```powershell
# Connects to a vCenter Server system associated with an SRM server. Then, establishes a connection to that SRM server by passing valid credentials for connection to the remote SRM server.
Connect-VIServer "myVCServerIp" -User "myUser" -Password "myPassword"
Connect-SrmServer -RemoteCredential $myRemoteCredential
```

### Option 3: Ignore Certificate Errors
```powershell
# Connects to a vCenter Server system, that has an associated SRM server. Then, establishes an SRM server connection by ignoring any errors related to bad server certificates. The newly created SRM server connection is not added to the default list of SRM server connections.
Connect-VIServer "myVCServerIp" -User "myUser" -Password "myPassword"
Connect-SrmServer -NotDefault -IgnoreCertificateErrors
```# Updated Sun Nov  9 12:50:15 CET 2025
