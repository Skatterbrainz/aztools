Function Get-ModuleVersionCheck {
	<#
	.SYNOPSIS
		Checks if the module already exists in the Automation Account and if it an equal or greater version
	.PARAMETER ModuleName
		The name of the module to check for
	.PARAMETER MinimumVersion
		The minimum required version of the module to check for
	#>
	[CmdletBinding()]
	[OutputType([boolean])]
	param (
		[parameter(Mandatory=$true)][string]$ModuleName,
		[parameter(Mandatory=$true)][string]$MinimumVersion
	)
	$params = @{
		ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
		AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
		Name                  = $ModuleName
		ErrorAction           = 'SilentlyContinue'
	}
	$ModuleCheck = Get-AzAutomationModule @params
	return $([version]$ModuleCheck.Version -ge [version]$MinimumVersion)
}
