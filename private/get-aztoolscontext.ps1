function Get-AzToolsContext {
	param()
	$res = $(
		[pscustomobject]@{
			Subscription      = (Get-AzContext).Subscription.Name
			SubscriptionID    = (Get-AzContext).Subscription.Id
			ResourceGroupName = $($global:AzToolsLastResourceGroup | Select-Object -ExpandProperty ResourceGroupname)
			AutomationAccount = $($global:AzToolsLastAutomationAccount | Select-Object -ExpandProperty AutomationAccountName)
		}
	)
	$res | ConvertTo-Json
}
