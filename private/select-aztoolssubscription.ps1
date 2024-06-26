function Select-AzToolsSubscription {
	[CmdletBinding()]
	param()
	Write-Verbose "Getting subscriptions"
	$azsubs = Get-AzSubscription
	Write-Host "Select: Azure Subscription" -ForegroundColor Cyan
	if (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
		if ($azsub = $azsubs | Out-ConsoleGridView -Title "Select Subscription" -OutputMode Single) {
			$global:AztoolsLastSubscription = $azsub
			$global:AztoolsLastTenantID = $azsub.TenantId
			Write-Host "Selected > $($azsub.Name) in Tenant: $($azsub.TenantId)" -ForegroundColor Cyan
		}
	} else {
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$global:AztoolsLastSubscription = $azsub
			$global:AztoolsLastTenantID = $azsub.TenantId
			Write-Host "Selected > $($azsub.Name) in Tenant: $($azsub.TenantId)" -ForegroundColor Cyan
		}
	}
}