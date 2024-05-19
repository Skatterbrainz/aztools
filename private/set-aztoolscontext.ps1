function Set-AzToolsContext {
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$True)]$Context
	)
	Write-Verbose "Checking of AzContext is set to: $($Context.Subscription.ID)"
	if ($(Get-AzContext).Subscription.SubscriptionId -ne $Context.Subscription.Id) {
		Write-Verbose "Setting AzContext to Subscription: $($Context.Subscription.ID)"
		$null    = Set-AzContext -SubscriptionId $Context.Subscription.Id -ErrorAction SilentlyContinue
		$context = Get-AzContext
		$valid   = $false
		if ($context) {
			try {$token = Get-AzAccessToken -ErrorAction Stop} catch {}
			if ($token) {
				if ($token.ExpiresOn -lt (Get-Date).AddMinutes(-5)) {
					$valid = $true
				}
			}
		}
		if (!$valid) {
			Connect-AzAccount
		}
		if ($(Get-AzContext).Subscription.SubscriptionId -ne $Context.Subscription.Id) {
			Write-Verbose "Forcing a reset of AzContext"
			Clear-AzContext -Scope CurrentUser -Force -ErrorAction SilentlyContinue
			Clear-AzDefault -Force -ErrorAction SilentlyContinue
			$null = Add-AzAccount -SubscriptionId $Context.Subscription.Id
			$global:AztoolsLastSubscription = $context.Subscription
			$global:AztoolsLastTenantID = $context.Tenant.Id
			Write-Host "Tenant > $($context.Tenant.Id) | Subscription > $($context.Subscription.Name) ($($context.Subscription.Id))" -ForegroundColor Cyan
		}
	}
}