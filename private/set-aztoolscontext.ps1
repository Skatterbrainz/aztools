function Set-AzToolsContext {
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$True)]$Context
	)
	Write-Verbose "Checking of AzContext is set to: $($Context.Subscription.ID)"
	if ($(Get-AzContext).Subscription.SubscriptionId -ne $Context.Subscription.Id) {
		Write-Verbose "Setting AzContext to Subscription: $($Context.Subscription.ID)"
		$null = Set-AzContext -SubscriptionId $Context.Subscription.Id -ErrorAction SilentlyContinue
		if ($(Get-AzContext).Subscription.SubscriptionId -ne $Context.Subscription.Id) {
			Write-Verbose "Forcing a reset of AzContext"
			Clear-AzContext -Scope CurrentUser -Force -ErrorAction SilentlyContinue
			Clear-AzDefault -Force -ErrorAction SilentlyContinue
			$null = Add-AzAccount -SubscriptionId $Context.Subscription.Id
		}
	}
}