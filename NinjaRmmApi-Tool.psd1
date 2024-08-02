<# 
This file is part of the NinjaRmmApi-Tool module. 
This module is not affiliated with, endorsed by, or related to NinjaRMM, LLC.

NinjaRmmApi-Tool is free software:  you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

NinjaRmmApi-Tool is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY;  without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with NinjaRmmApi-Tool.  If not, see <https://www.gnu.org/licenses/>.
#>

@{
    RootModule = 'NinjaRmmApi-Tool.psm1'
    ModuleVersion = '1.0.0'
    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion = '5.1'
    GUID = 'aaa3b5ab-8861-4ce4-b0aa-f2089dee9cf2'
    Author = 'Your Name'
    Copyright = '(c) 2024 Your Name. Forked from Colin Cogle. All rights reserved. Licensed under the AGPL version 3.'
    Description = 'An unofficial PowerShell module to interact with NinjaRMM. Forked from Colin Cogle''s NinjaRmmApi.'
    FunctionsToExport = @(
        'Get-NinjaRmmAlerts',
        'Get-NinjaRmmCustomers',
        'Get-NinjaRmmDevices',
        'Reset-NinjaRmmAlert',
        'Reset-NinjaRmmSecrets',
        'Set-NinjaRmmSecrets',
        'Set-NinjaRmmServerLocation'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @(
        'Remove-NinjaRmmAlert',
        'Remove-NinjaRmmSecrets'
    )
    FileList = @(
        'en-US/about_NinjaRmmApi-Tool.help.txt',
        'en-US/NinjaRmmApi-Tool-help.xml',
        'CHANGELOG.md',
        'LICENSE',
        'NEWS.md',
        'NinjaRmmApi-Tool.png',
        'NinjaRmmApi-Tool.psd1',
        'NinjaRmmApi-Tool.psm1',
        'README.md'
    )
    PrivateData = @{
        PSData = @{
            Tags = @('Ninja', 'NinjaRMM', 'RMM', 'API', 'computers', 'devices', 'alerts', 'customers', 'REST', 'Windows', 'cloud', 'network', 'macOS')
            LicenseUri = 'https://github.com/kalichuza/NinjaRmmApi-Tool/blob/main/LICENSE'
            ProjectUri = 'https://github.com/kalichuza/NinjaRmmApi-Tool/'
            IconUri = 'https://raw.githubusercontent.com/kalichuza/NinjaRmmApi-Tool/main/NinjaRmmApi-Tool.png'
            ReleaseNotes = 'https://github.com/kalichuza/NinjaRmmApi-Tool/blob/main/NEWS'
            Prerelease = ''
            RequireLicenseAcceptance = $false
        }
    }
}
