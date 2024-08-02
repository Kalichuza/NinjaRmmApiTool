<#
This file is part of the NinjaRmmApiTool module.
This module is not affiliated with, endorsed by, or related to NinjaRMM, LLC.

NinjaRmmApiTool is free software:  you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

NinjaRmmApiTool is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY;  without even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with NinjaRmmApiTool.  If not, see <https://www.gnu.org/licenses/>.
#>

@{
    RootModule = 'NinjaRmmApiTool.psm1'
    ModuleVersion = '1.0.1'  # Incremented version number
    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion = '5.1'
    GUID = 'aaa3b5ab-8861-4ce4-b0aa-f2089dee9cf2'
    Author = 'Your Name'
    Description = 'An unofficial PowerShell module to interact with NinjaRMM. Forked from Colin Cogle''s NinjaRmmApi.'
    FunctionsToExport = @(
        'Get-NinjaRmmApiToolAlerts',
        'Get-NinjaRmmApiToolCustomers',
        'Get-NinjaRmmApiToolDevices',
        'Reset-NinjaRmmApiToolAlert',
        'Reset-NinjaRmmApiToolSecrets',
        'Set-NinjaRmmApiToolSecrets',
        'Set-NinjaRmmApiToolServerLocation'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @(
        'Remove-NinjaRmmApiToolAlert',
        'Remove-NinjaRmmApiToolSecrets'
    )
    FileList = @(
        'en-US/about_NinjaRmmApiTool.help.txt',
        'en-US/NinjaRmmApiTool-help.xml',
        'CHANGELOG.md',
        'LICENSE',
        'NEWS.md',
        'NinjaRmmApiTool.png',
        'NinjaRmmApiTool.psd1',
        'NinjaRmmApiTool.psm1',
        'README.md'
    )
    PrivateData = @{
        PSData = @{
            Tags = @('Ninja', 'NinjaRMM', 'RMM', 'API', 'computers', 'devices', 'alerts', 'customers', 'REST', 'Windows', 'cloud', 'network', 'macOS')
            LicenseUri = 'https://github.com/kalichuza/NinjaRmmApi-Tool/blob/main/LICENSE'
            ProjectUri = 'https://github.com/kalichuza/NinjaRmmApi-Tool/'
            IconUri = 'https://raw.githubusercontent.com/kalichuza/NinjaRmmApi-Tool/main/NinjaRmmApiTool.png'
            ReleaseNotes = 'https://github.com/kalichuza/NinjaRmmApi-Tool/blob/main/NEWS'
            Prerelease = ''
            RequireLicenseAcceptance = $false
        }
    }
}
