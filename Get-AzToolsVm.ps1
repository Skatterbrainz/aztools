function Get-AzToolsVm {
	<#
	.SYNOPSIS
		Get Azure Virtual Machines by searching on Tag name/value or Extension
	.DESCRIPTION
		Get Azure Virtual Machines by searching on Tag name/value or Extension
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER AllSubscriptions
		Optional. Enumerate machines in all subscriptions.
		Default = Enumerate machines in the current/active context subscription only.
	.PARAMETER TagName
		Optional. Tag name to search for
	.PARAMETER TagValue
		Required if -TagName is used. Value assigned to TagName to filter on
	.PARAMETER ExtensionName
		Optional. Name of Azure VM extension
	.EXAMPLE
		Get-AzToolsVm -TagName "PatchGroup" -TagValue "Group2"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)][string]$TagName,
		[parameter(Mandatory=$false)][string]$TagValue = "",
		[parameter(Mandatory=$false)][switch]$SelectContext,
		[parameter(Mandatory=$false)][switch]$AllSubscriptions,
		[parameter(Mandatory=$false)][string]$ExtensionName = ""
	)
	if ($SelectContext) { Switch-AzToolsContext }
	$currentContext = (Get-AzContext)
	if ($AllSubscriptions) {
		[array]$azsubs = (Get-AzSubscription)
	} else {
		[array]$azsubs = $(Get-AzContext).Subscription
	}
	foreach ($azsub in $azsubs) {
		Write-Host "Subscription: $($azsub.Name) - $($azsub.Id)" -ForegroundColor Cyan
		$null = Select-AzSubscription -Subscription $azsub
		$machines = $null
		if ([string]::IsNullOrWhiteSpace($TagValue)) {
			[array](Get-AzVm -Status | Where-Object {-not ([string]::IsNullOrWhiteSpace($_.Tags["$TagName"])) } | Select-Object -Property *,@{l="$TagName";e={$_.Tags["$TagName"]}} | Sort-Object "$TagName", Name)
		} else {
			[array](Get-AzVm -Status | Where-Object {$_.Tags["$TagName"] -eq "$TagValue"})
		}
	}
	if ($currentContext -ne (Get-AzContext)) {
		$null = Set-AzContext $currentContext
	}
}