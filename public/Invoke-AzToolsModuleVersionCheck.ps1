Function Invoke-AzToolsModuleVersionCheck {
	<#
	.SYNOPSIS
		Checks if the module already exists in the Automation Account and if it an equal or greater version
	.PARAMETER ModuleName
		The name of the module to check for
	.PARAMETER MinimumVersion
		The minimum required version of the module to check for
	.EXAMPLE
		Invoke-AzToolsModuleVersionCheck -ModuleName "az.accounts" -MinimumVersion "2.12.1"
	.NOTES
		This was adapted from code by Matthew Dowst / @mdowst
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsModuleVersionCheck.md
	#>
	[CmdletBinding()]
	[OutputType([boolean])]
	param (
		[parameter(Mandatory=$true)][string]$ModuleName,
		[parameter(Mandatory=$true)][string]$MinimumVersion
	)
	try {
		if ($global:AzToolsLastAutomationAccount -and $global:AzToolsLastResourceGroup) {
			$params = @{
				ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
				AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
				Name                  = $ModuleName
				ErrorAction           = 'SilentlyContinue'
			}
			$ModuleCheck = Get-AzAutomationModule @params
			return $([version]$ModuleCheck.Version -ge [version]$MinimumVersion)
		} else {
			throw "ResourceGroup or Automation Account have not been selected yet"
		}
	} catch {
		Write-Error $_.Exception.Message
	}
}
