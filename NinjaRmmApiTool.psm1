Function Set-NinjaSecrets {
    [OutputType('void')]
    Param(
        [AllowNull()]
        [String] $AccessKeyId,

        [AllowNull()]
        [String] $SecretAccessKey
    )

    $global:NinjaRmmAccessKeyID = $AccessKeyId
    $global:NinjaRmmSecretAccessKey = $SecretAccessKey
}



Function Reset-NinjaSecrets {
    [Alias('Remove-NinjaSecrets')]
    [OutputType('void')]
    Param()

    Remove-Variable -Name $global:NinjaRmmAccessKeyID
    Remove-Variable -Name $global:NinjaRmmSecretAccessKey
}

Function Set-NinjaServerLocation {
    [OutputType('void')]
    Param(
        [ValidateSet('US', 'EU')]
        [String] $Location = 'US'
    )

    $global:NinjaRmmServerLocation = $Location
}

Function Set-NinjaOAuthEndpoint {
    [OutputType('void')]
    Param(
        [Parameter(Mandatory = $true)]
        [String] $OAuthEndpoint
    )

    $global:NinjaRmmOAuthEndpoint = $OAuthEndpoint
}

Function Set-NinjaScope {
    [OutputType('void')]
    Param(
        [Parameter(Mandatory = $true)]
        [String] $Scope
    )

    $global:NinjaRmmScope = $Scope
}

Function Get-AccessToken {
    param (
        [Parameter(Mandatory = $true)]
        [String] $TokenUrl,

        [Parameter(Mandatory = $true)]
        [String] $ClientID,

        [Parameter(Mandatory = $true)]
        [String] $ClientSecret
    )

    # Use the global scope variable
    $Scope = $global:NinjaRmmScope

    $Body = "grant_type=client_credentials&client_id=$([uri]::EscapeDataString($ClientID))&client_secret=$([uri]::EscapeDataString($ClientSecret))&scope=$([uri]::EscapeDataString($Scope))"
    $Headers = @{
        'Content-Type' = 'application/x-www-form-urlencoded'
    }

    Write-Verbose "Request Body: $Body"
    Write-Verbose "Request Headers: $($Headers | Out-String)"

    try {
        $Response = Invoke-RestMethod -Uri $TokenUrl -Method Post -Headers $Headers -Body $Body
        Write-Verbose "Authentication successful. Access token retrieved."
        return $Response.access_token
    }
    catch {
        Write-Error "Error in getting access token: $($_.Exception.Response.StatusCode) $($_.Exception.Response.StatusDescription)"
        Write-Error "Detailed Error: $($_.Exception.Message)"
        return $null
    }
}



Function Send-NinjaRequest {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $RequestToSend,

        [ValidateSet('GET', 'PUT', 'POST', 'DELETE')]
        [String] $Method = 'GET'
    )

    If ($null -eq $global:NinjaRmmSecretAccessKey) {
        Throw [Data.NoNullAllowedException]::new('No secret access key has been provided.  Please run Set-NinjaSecrets.')
    }
    If ($null -eq $global:NinjaRmmAccessKeyID) {
        Throw [Data.NoNullAllowedException]::new('No access key ID has been provided.  Please run Set-NinjaSecrets.')
    }

    $AccessToken = Get-AccessToken -TokenUrl $global:NinjaRmmOAuthEndpoint -ClientID $global:NinjaRmmAccessKeyID -ClientSecret $global:NinjaRmmSecretAccessKey

    If ($null -eq $AccessToken) {
        Throw [System.Exception]::new('Failed to retrieve access token.')
    }

    If (($global:NinjaRmmServerLocation -eq 'US') -or ($null -eq $global:NinjaRmmServerLocation)) {
        $HostName = 'api.ninjarmm.com'
    }
    ElseIf ($global:NinjaRmmServerLocation -eq 'EU') {
        $HostName = 'eu-api.ninjarmm.com'
    }
    Else {
        Throw [ArgumentException]::new("The server location ${global:NinjaRmmServerLocation} is not valid.  Please run Set-NinjaServerLocation.")
    }

    $UserAgent = "PowerShell/$($PSVersionTable.PSVersion) "
    $UserAgent += "NinjaRmmApiTool/$((Get-Module -Name 'NinjaRmmApiTool').Version) "
    $UserAgent += '(implementing API version 0.1.2)'

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    If ([Net.SecurityProtocolType].GetMembers() -Contains 'Tls13') {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls13
    }

    Write-Debug -Message ("Will send the request:`n`n" `
            + "$Method $RequestToSend HTTP/1.1`n" `
            + "Host: $HostName`n" `
            + "Authorization: Bearer $AccessToken`n" `
            + "User-Agent: $UserAgent")

    $Arguments = @{
        'Method'  = $Method
        'Uri'     = "https://$HostName$RequestToSend"
        'Headers' = @{
            'Authorization' = "Bearer $AccessToken"
            'Host'          = $HostName
            'User-Agent'    = $UserAgent
        }
    }

    Return (Invoke-RestMethod @Arguments)
}

Function Get-NinjaAlerts {
    [CmdletBinding(DefaultParameterSetName = 'AllAlerts')]
    Param(
        [Parameter(ParameterSetName = 'OneAlert')]
        [UInt32] $AlertId,

        [Parameter(ParameterSetName = 'AllAlertsSince')]
        [UInt32] $Since
    )

    $Request = '/v2/alerts'
    If ($PSCmdlet.ParameterSetName -eq 'OneAlert') {
        $Request += "/$AlertId"
    }
    ElseIf ($PSCmdlet.ParameterSetName -eq 'AllAlertsSince') {
        $Request += "/since/$Since"
    }

    $alerts = Send-NinjaRequest -RequestToSend $Request

    # Function to convert Unix epoch time to human-readable format
    Function Convert-UnixTime {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $true, Position = 0)]
            [Double] $UnixTime
        )

        $epoch = [DateTime]"1970-01-01 00:00:00Z"
        $humanReadableTime = $epoch.AddSeconds($UnixTime).ToLocalTime()
        return $humanReadableTime
    }

    # Convert the timestamps
    foreach ($alert in $alerts) {
        $alert.createTime = Convert-UnixTime -UnixTime $alert.createTime
        $alert.updateTime = Convert-UnixTime -UnixTime $alert.updateTime
    }

    return $alerts
}

Function Reset-NinjaAlert {
    [CmdletBinding()]
    [Alias('Remove-NinjaAlert')]
    Param(
        [Parameter(Mandatory)]
        [UInt32] $AlertId
    )

    Return (Send-NinjaRequest -Method 'DELETE' -RequestToSend "/v1/alerts/$AlertId")
}

Function Get-NinjaCustomers {
    [CmdletBinding(DefaultParameterSetName='AllCustomers')]
    Param(
        [Parameter(ParameterSetName='OneCustomer')]
        [UInt32] $CustomerId,

        [Parameter(ParameterSetName='AllCustomers')]
        [UInt32] $PageSize = 50
    )

    $Request = "/v2/organizations?pageSize=$PageSize"
    If ($PSCmdlet.ParameterSetName -eq 'OneCustomer') {
        $Request = "/v2/organizations/$CustomerId"
    }

    Return (Send-NinjaRequest -RequestToSend $Request)
}
Function Get-NinjaDevices {
    [CmdletBinding(DefaultParameterSetName='AllDevices')]
    Param(
        [Parameter(ParameterSetName='OneDevice')]
        [UInt32] $DeviceId,

        [Parameter(ParameterSetName='AllDevices')]
        [UInt32] $PageSize = 500
    )

    $Request = "/v2/devices?pageSize=$PageSize"
    If ($PSCmdlet.ParameterSetName -eq 'OneDevice') {
        $Request = "/v2/devices/$DeviceId"
    }

    $devices = Send-NinjaRequest -RequestToSend $Request

    # Function to convert Unix epoch time to human-readable format
    Function Convert-UnixTime {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $true, Position = 0)]
            [Double] $UnixTime
        )

        $epoch = [DateTime]"1970-01-01 00:00:00Z"
        $humanReadableTime = $epoch.AddSeconds($UnixTime).ToLocalTime()
        return $humanReadableTime
    }

    # Convert the timestamps for each device
    foreach ($device in $devices) {
        if ($device.createTime) {
            $device.createTime = Convert-UnixTime -UnixTime $device.createTime
        }
        if ($device.lastContact) {
            $device.lastContact = Convert-UnixTime -UnixTime $device.lastContact
        }
        if ($device.lastUpdate) {
            $device.lastUpdate = Convert-UnixTime -UnixTime $device.lastUpdate
        }
    }

    return $devices
}

