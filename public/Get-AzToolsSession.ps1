function Get-AzToolsSession {
	<#
	.SYNOPSIS
		Show Active AZTools context
	.DESCRIPTION
		Show details about current AZTools context, such as TenantID, SubscriptionID,
		Subscription Name, ResourceGroup Name and Automation Account Name
	.PARAMETER (none)
	.EXAMPLE
		Get-AzToolsSession
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsSession.md
	#>
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
