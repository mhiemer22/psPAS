Function Get-PASPTARemediation {
	<#
	.SYNOPSIS
	Returns automatic remediation settings from PTA

	.DESCRIPTION
	Returns automatic remediation settings configured in PTA

	.PARAMETER sessionToken
	Hashtable containing the session token returned from New-PASSession

	.PARAMETER WebSession
	WebRequestSession object returned from New-PASSession

	.PARAMETER BaseURI
	PVWA Web Address
	Do not include "/PasswordVault/"

	.PARAMETER PVWAAppName
	The name of the CyberArk PVWA Virtual Directory.
	Defaults to PasswordVault

	.PARAMETER ExternalVersion
	The External CyberArk Version, returned automatically from the New-PASSession function from version 9.7 onwards.

	.EXAMPLE
	$token | Get-PASPTARemediation

	Returns all automatic remediation settings from PTA

	.NOTES
	General notes
	#>
	[CmdletBinding()]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$sessionToken,

		[parameter(ValueFromPipelinebyPropertyName = $true)]
		[Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$BaseURI,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$PVWAAppName = "PasswordVault",

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[System.Version]$ExternalVersion = "0.0"

	)

	BEGIN {
		$MinimumVersion = [System.Version]"10.4"
	}#begin

	PROCESS {

		Assert-VersionRequirement -ExternalVersion $ExternalVersion -RequiredVersion $MinimumVersion

		#Create request URL
		$URI = "$baseURI/$PVWAAppName/API/pta/API/Settings"

		#Send request to web service
		$result = Invoke-PASRestMethod -Uri $URI -Method GET -Headers $SessionToken -WebSession $WebSession

		If($result) {

			#Return Results
			$result.automaticRemediation |

			Add-ObjectDetail -typename psPAS.CyberArk.Vault.PTA.Remediation  -PropertyToAdd @{

				"sessionToken"    = $sessionToken
				"WebSession"      = $WebSession
				"BaseURI"         = $BaseURI
				"PVWAAppName"     = $PVWAAppName
				"ExternalVersion" = $ExternalVersion

			}

		}

	}#process

	END {}#end
}