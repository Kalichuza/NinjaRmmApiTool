# NinjaRmmApiTool

This module is a fork of the [NinjaRmmApi](https://github.com/rhymeswithmogul/NinjaRMM-PowerShell) module by [Colin Cogle](https://github.com/rhymeswithmogul).

## Changes

Version 1.0.1 up now on PSGallery 
## Installation
```powershell
Install-Module -Name NinjaRmmApiTool -AllowClobber -Force
```

<hr>

![NinjaRmmApiTool logo](https://github.com/Kalichuza/NinjaRmmApiTool/blob/main/NinjaRmmApiTool.png?raw=true)
# NinjaRmmApiTool
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://github.com/rhymeswithmogul/NinjaRMM-PowerShell/blob/main/CODE_OF_CONDUCT.md) 

A PowerShell module to interact with [the NinjaRMM Public API](https://www.ninjarmm.com/dev-api/).  This currently complies with [beta version 2.0 of the API]([https://ninjaresources.s3.amazonaws.com/PublicApi/0.1.2/NinjaRMM%20Public%20API%20v0.1.2.pdf](https://companyname.rmmservice.com/apidocs/?links.active=core)).

## Installing this module
This module will soon be available in [PowerShell Gallery](https://www.powershellgallery.com/packages/NinjaRmmApiTool/):
```powershell
Install-Module -Name NinjaRmmApiTool -AllowClobber -Force
```
Or, download it from here and save all of the files somewhere in your `$PSModulePath`.

## Before you start
To get started with this module, you will need to log into your dashboard and [request an API key](https://app.ninjarmm.com/#/configuration/integrations/api).  Write down the access key ID and the secret access key.  You will not see them again!

Then, in your PowerShell session, teach it your secrets with `Set-NinjaSecrets`.
```powershell
Set-NinjaSecrets -AccessKeyID "TF4STGMDR4H7AEXAMPLE" -SecretAccessKey "eh14c4ngchhu6283he03j6o7ar2fcuca0example"
```
You will need to do this every time you start a new PowerShell session;  this module does *not* store your keys for you!  For long-term storage, consider using a password manager, sticking the keys in your `$Profile` file, or using the [SecretManagement module](https://github.com/powershell/secretmanagement).  How you do this is an exercise left to the reader.

## Using this module
Now that that's been done, start using their API!
### Scope
*This is an optional parameter. Version 1.01 has the scope for each fuction built in. This feature will be depricated in subsequent versions of the module.

But for now... Note that there are two options when it comes to the scope of the Oauth tokens. They are, monitoring and management. For now these are the only two you will need.
```powershell
Set-NijnaScope -Scope 'monitoring'
```

### Customers
You can look up customer information with the `Get-NinjaCustomers` cmdlet.  With no arguments, it returns a list of all customers.  You can also use the -CustomerID parameter to fetch a specific customer.  The NinjaRMM API returns data as objects that you can parse with other PowerShell cmdlets like `Format-List` and `Select-Object` (and, of course, everyone's favorite, `Out-GridView`!).
```powershell
Get-NinjaCustomers -CustomerID 42

id name         description
-- ----         --------------
42 Deep Thought Bring a towel.
```

### Devices
You can get devices in the same manner, by using `Get-NinjaDevices`.  Again, your results are PowerShell objects that you can work with.
```powershell
PS C:\> $myComputer = Get-NinjaDevices -DeviceID 528
PS C:\> $myComputer.System | Format-List

manufacturer       : Hewlett-Packard
name               : RECEPTION-PC
model              : HP Z400 Workstation
dns_host_name      : Reception-PC
bios_serial_number : 2UA1234567
serial_number      : 2UA1234567
domain             : WORKGROUP
```

### Alerts
You can get and reset alerts, too:
```powershell
$alertsToReviewLater = Get-NinjaAlerts -Since 3071641

ReSet-NinjaAlert -AlertID 3071642
```

## After you're done
When you are finished, it is best practice to remove your API key from memory:
```powershell
ReSet-NinjaSecrets
```

## What else can I do?
There is plenty of help to read.  Get started with this:
```powershell
Get-Help about_NinjaRmmApiTool
```

## Legal Notices
Neither I nor this code are in any way affiliated with, related to, or endorsed by NinjaRMM, LLC.  I'm just a user.  If you need support with this PowerShell module, don't go to them.  Open an issue or pull request instead.

This program is free software:  you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.  Test anything you build with this tool.

## Contributing
The NinjaRMM API is under active development;  thus, so is this module.  Contributions are welcome!
