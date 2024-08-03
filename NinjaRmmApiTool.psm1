Function Set-NinjaRmmApiToolSecrets {
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

Function Reset-NinjaRmmApiToolSecrets {
	[Alias('Remove-NinjaRmmApiToolSecrets')]
	[OutputType('void')]
	Param()

	Remove-Variable -Name $global:NinjaRmmAccessKeyID
	Remove-Variable -Name $global:NinjaRmmSecretAccessKey
}

Function Set-NinjaRmmApiToolServerLocation {
	[OutputType('void')]
	Param(
		[ValidateSet('US', 'EU')]
		[String] $Location = 'US'
	)

	$global:NinjaRmmServerLocation = $Location
}

Function Set-NinjaRmmApiToolOAuthEndpoint {
	[OutputType('void')]
	Param(
		[Parameter(Mandatory = $true)]
		[String] $OAuthEndpoint
	)

	$global:NinjaRmmOAuthEndpoint = $OAuthEndpoint
}

Function Get-AccessToken {
	param (
		[Parameter(Mandatory = $true)]
		[String] $TokenUrl,

		[Parameter(Mandatory = $true)]
		[String] $ClientID,

		[Parameter(Mandatory = $true)]
		[String] $ClientSecret,

		[String] $Scope = 'monitoring'
	)

	$Body = @{
		grant_type    = 'client_credentials'
		client_id     = $ClientID
		client_secret = $ClientSecret
		scope         = $Scope
	}

	$Body = $Body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($([uri]::EscapeDataString($_.Value)))" } -join "&"
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

Function Get-NinjaRmmApiToolCustomers {
	[CmdletBinding()]
	Param(
		[Parameter(ParameterSetName = 'OneCustomer')]
		[UInt32] $CustomerId,

		[Parameter(ParameterSetName = 'AllCustomers')]
		[UInt32] $PageSize = 10
	)

	$Request = "/v2/organizations?pageSize=$PageSize"
	If ($PSCmdlet.ParameterSetName -eq 'OneCustomer') {
		$Request = "/v2/organizations/$CustomerId"
	}

	Return (Send-NinjaRmmApiTool -RequestToSend $Request)
}


Function Send-NinjaRmmApiTool {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String] $RequestToSend,

		[ValidateSet('GET', 'PUT', 'POST', 'DELETE')]
		[String] $Method = 'GET'
	)

	# Stop if our secrets have not been learned.
	If ($null -eq $global:NinjaRmmSecretAccessKey) {
		Throw [Data.NoNullAllowedException]::new('No secret access key has been provided.  Please run Set-NinjaRmmApiToolSecrets.')
	}
	If ($null -eq $global:NinjaRmmAccessKeyID) {
		Throw [Data.NoNullAllowedException]::new('No access key ID has been provided.  Please run Set-NinjaRmmApiToolSecrets.')
	}

	# Get the access token
	$AccessToken = Get-AccessToken -TokenUrl $global:NinjaRmmOAuthEndpoint -ClientID $global:NinjaRmmAccessKeyID -ClientSecret $global:NinjaRmmSecretAccessKey

	If ($null -eq $AccessToken) {
		Throw [System.Exception]::new('Failed to retrieve access token.')
	}

	# Pick our server.  By default, we will use the United States server.
	# However, the European Union server can be used instead.'
	If (($global:NinjaRmmServerLocation -eq 'US') -or ($null -eq $global:NinjaRmmServerLocation)) {
		$HostName = 'api.ninjarmm.com'
	}
	ElseIf ($global:NinjaRmmServerLocation -eq 'EU') {
		$HostName = 'eu-api.ninjarmm.com'
	}
	Else {
		Throw [ArgumentException]::new("The server location ${global:NinjaRmmServerLocation} is not valid.  Please run Set-NinjaRmmApiToolServerLocation.")
	}

	# Create a user agent for logging purposes.
	$UserAgent = "PowerShell/$($PSVersionTable.PSVersion) "
	$UserAgent += "NinjaRmmApiTool/$((Get-Module -Name 'NinjaRmmApiTool').Version) "
	$UserAgent += '(implementing API version 0.1.2)'

	# Ensure that TLS 1.2 is enabled, so that we can communicate with NinjaRMM.
	# It may be disabled by default before PowerShell 6.
	[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

	# Some new versions of PowerShell also support TLS 1.3.  If that is a valid
	# option, then enable that, too, in case NinjaRMM ever enables it.
	If ([Net.SecurityProtocolType].GetMembers() -Contains 'Tls13') {
		[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls13
	}

	# Finally, send it.
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

Function Get-NinjaRmmApiToolAlerts {
	[CmdletBinding(DefaultParameterSetName = 'AllAlerts')]
	Param(
		[Parameter(ParameterSetName = 'OneAlert')]
		[UInt32] $AlertId,

		[Parameter(ParameterSetName = 'AllAlertsSince')]
		[UInt32] $Since
	)

	$Request = '/v1/alerts'
	If ($PSCmdlet.ParameterSetName -eq 'OneAlert') {
		$Request += "/$AlertId"
	}
	ElseIf ($PSCmdlet.ParameterSetName -eq 'AllAlertsSince') {
		$Request += "/since/$Since"
	}

	Return (Send-NinjaRmmApiTool -RequestToSend $Request)
}

Function Reset-NinjaRmmApiToolAlert {
	[CmdletBinding()]
	[Alias('Remove-NinjaRmmApiToolAlert')]
	Param(
		[Parameter(Mandatory)]
		[UInt32] $AlertId
	)

	Return (Send-NinjaRmmApiTool -Method 'DELETE' -RequestToSend "/v1/alerts/$AlertId")
}

Function Get-NinjaRmmApiToolCustomers {
	[CmdletBinding(DefaultParameterSetName = 'AllCustomers')]
	Param(
		[Parameter(ParameterSetName = 'OneCustomer')]
		[UInt32] $CustomerId,

		[Parameter(ParameterSetName = 'AllCustomers')]
		[UInt32] $PageSize = 10
	)

	$Request = "/v2/organizations?pageSize=$PageSize"
	If ($PSCmdlet.ParameterSetName -eq 'OneCustomer') {
		$Request = "/v2/organizations/$CustomerId"
	}

	Return (Send-NinjaRmmApiTool -RequestToSend $Request)
}


Function Get-NinjaRmmApiToolDevices {
	[CmdletBinding(DefaultParameterSetName = 'AllDevices')]
	Param(
		[Parameter(ParameterSetName = 'OneDevice')]
		[UInt32] $DeviceId
	)

	$Request = '/v1/devices'
	If ($PSCmdlet.ParameterSetName -eq 'OneDevice') {
		$Request += "/$DeviceId"
	}
	Return (Send-NinjaRmmApiTool -RequestToSend $Request)
}
