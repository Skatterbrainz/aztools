function Select-AzToolsResourceGroup {
	[CmdletBinding()]
	param()
	if ($global:AzToolsLastSubscription) {
		if ((Get-AzContext).Subscription.Id -ne $AzToolsLastSubscription.Id) {
			$null = Set-AzContext -SubscriptionObject $AzToolsLastSubscription
		}
		Write-Verbose "Getting resource groups"
		$rglist = Get-AzResourceGroup
		Write-Host "Select: Resource Group" -ForegroundColor Cyan
		if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
			$global:AzToolsLastResourceGroup = $rg
		}
	} else {
		Write-Warning "Subscription not selected. Use Switch-AzToolsContext"
	}
}

