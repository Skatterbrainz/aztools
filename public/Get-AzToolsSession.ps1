function Get-AzToolsSession {
	param()
	$res = $(
		$ctx = Get-AzContext
		[pscustomobject]@{
			TenantId          = $ctx.Tenant.Id
			Subscription      = $ctx.Subscription.Name
			SubscriptionID    = $ctx.Subscription.Id
			ResourceGroupName = $($global:AzToolsLastResourceGroup | Select-Object -ExpandProperty ResourceGroupname)
			AutomationAccount = $($global:AzToolsLastAutomationAccount | Select-Object -ExpandProperty AutomationAccountName)
		}
	)
	$res | ConvertTo-Json
}
