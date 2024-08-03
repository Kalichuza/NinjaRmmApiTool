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
    ModuleVersion = '1.0.1'  # Incremented version number for new changes
    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion = '5.1'  # Ensure compatibility with PowerShell 5.1 and above
    GUID = 'aaa3b5ab-8861-4ce4-b0aa-f2089dee9cf2'
    Author = 'Kalichuza'
    Description = 'A very unofficial PowerShell module to interact with NinjaRMM. Forked from Colin Cogle''s NinjaRmmApi.'
    FunctionsToExport = @(
        'Get-NinjaAlerts',
        'Get-NinjaCustomers',
        'Get-NinjaDevices',
        'Get-NinjaSoftwareInventory',
        'Reset-NinjaAlert',
        'Reset-NinjaSecrets',
        'Set-NinjaSecrets',
        'Set-NinjaServerLocation',
        'Set-NinjaOAuthEndpoint',
        'Set-NinjaScope',
        'Reboot-NinjaDevice'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @(
        'Remove-NinjaAlert',
        'Remove-NinjaSecrets'
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
