function Get-AzToolsAutomationModuleDetails {
	<#
	.SYNOPSIS
		Get the module details from the PowerShell Gallery and returns any dependencies
	.PARAMETER ModuleName
		The name of the module to look up
	.EXAMPLE
		Get-AzToolsAutomationModuleDetails -ModuleName "az.accounts"
	.NOTES
		This was adapted from code by Matthew Dowst / @mdowst
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationModuleDetails.md
	#>
	[CmdletBinding()]
	[OutputType([object])]
	param(
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext
	)
	$Module = Find-Module -Name $ModuleName
	$Module.Dependencies | ForEach-Object { Get-AzModuleDetails -ModuleName $_['Name'] }
	$Module
}