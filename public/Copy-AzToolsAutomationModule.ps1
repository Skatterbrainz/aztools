<#
.SYNOPSIS
.DESCRIPTION
.PARAMETER
.EXAMPLE
.NOTES
#>
function Copy-AzToolsAutomationModule {
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext
	)
	$modules = Get-AzToolsAutomationModule -SelectContext:$SelectContext
	if ($modules.Count -gt 0) {
		$copyList = $modules | Out
	}
}