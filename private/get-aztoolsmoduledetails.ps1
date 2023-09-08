Function Get-AzToolsModuleDetails {
	<#
	.SYNOPSIS
		Get the module details from the PowerShell Gallery and returns any dependencies
	.PARAMETER ModuleName
		The name of the module to look up
	#>
	[CmdletBinding()]
	[OutputType([object])]
	param(
		[parameter(Mandatory=$true)][string]$ModuleName
	)
	$Module = Find-Module -Name $ModuleName
	$Module.Dependencies | ForEach-Object { Get-AzModuleDetails -ModuleName $_['Name'] }
	$Module
}