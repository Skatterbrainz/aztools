function Show-AzToolsContext {
	<#
	.SYNOPSIS
		Show current Azure Connection Context summary
	.DESCRIPTION
		Show current Azure Connection Context summary
	.PARAMETER (none)
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Show-AzToolsContext.md
	#>
	[CmdletBinding()]
	param()
	Get-AzContext -ListAvailable | Sort-Object Name
	$ctx = Get-AzContext
	Write-Host "Current context: $($ctx.Name) - $($ctx.Account.Id) - $($ctx.Subscription.Id)" -ForegroundColor Cyan
}