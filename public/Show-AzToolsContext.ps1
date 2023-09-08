function Show-AzToolsContext {
	[CmdletBinding()]
	param()
	Get-AzContext -ListAvailable | Sort-Object Name
	$ctx = Get-AzContext
	Write-Host "Current context: $($ctx.Name) - $($ctx.Account.Id) - $($ctx.Subscription.Id)" -ForegroundColor Cyan
}