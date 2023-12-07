function Get-AzToolsCostSummary {
	<#
	.SYNOPSIS
		Get Billing Invoice Summary
	.DESCRIPTION
		Get Billing Invoice Summary for Azure Billing Account
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Latest
		Optional. Return the latest invoice only. Default is to return all available invoices.
	.EXAMPLE
		Get-AzToolsCostSummary

		Returns all available invoices for the current Azure context.
	.EXAMPLE
		Get-AzToolsCostSummary -SelectContext

		Prompts to select Azure context, then returns all available invoices.
	.EXAMPLE
		Get-AzToolsCostSummary -Latest

		Returns the latest invoice only.
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