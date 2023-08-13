function Get-AzToolsVmByTag {
	<#
	.SYNOPSIS
		Get Azure Virtual Machines by searching on Tag name and value
	.DESCRIPTION
		Get Azure Virtual Machines by searching on Tag name and value
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER TagName
		Required. Tag name to search for
	.PARAMETER TagValue
		Required. Value assigned to TagName to filter on
	.EXAMPLE
		Get-AzToolsVmByTag -TagName "PatchGroup" -TagValue "Group2"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter(Mandatory)][string]$TagName,
		[parameter(Mandatory)][string]$TagValue
	)
	if ($SelectContext) {
		Switch-AzToolsContext
	}
	[array]$azsubs = (Get-AzSubscription)
	foreach ($azsub in $azsubs) {
		Write-Host "Subscription: $($azsub.Name) - $($azsub.Id)" -ForegroundColor Cyan
		$null = Select-AzSubscription -Subscription $azsub
		$machines = $null
		[array](Get-AzVm -Status | Where-Object {$_.Tags[$TagName] -eq $TagValue})
	}
}