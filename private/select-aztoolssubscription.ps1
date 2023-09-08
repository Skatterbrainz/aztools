function Select-AzToolsSubscription {
	[CmdletBinding()]
	param()
	Write-Verbose "Getting subscriptions"
	$azsubs = Get-AzSubscription
	Write-Host "Select: Azure Subscription" -ForegroundColor Cyan
	if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
		$global:AztoolsLastSubscription = $azsub
	}
}