function Get-AzToolsCostSummary {
	<#
	.SYNOPSIS
		Get Latest Billing Invoice Summary
	.DESCRIPTION
		Get Latest Billing Invoice Summary for each Azure Billing Account
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Latest
		Optional. Return the latest invoice only. Default is to return all available invoices.
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$Latest
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	Get-AzBillingAccount | Foreach-Object {
		$ba = $_.Name
		$bplist = Get-AzBillingPeriod | Where-Object {$null -ne $_.InvoiceNames} | Select-Object Name,BillingPeriodStartDate,BillingPeriodEndDate,InvoiceNames
		if ($Latest) {
			Get-AzBillingInvoice -Latest
		} else {
			$bplist | Foreach-Object { Get-AzBillingInvoice -Name $_.InvoiceNames }
		}
	}
}