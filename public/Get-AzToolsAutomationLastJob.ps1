Function Get-AzToolsAutomationLastJob {
	<#
	.SYNOPSIS
		Get date and time of most recent Runbook job execution
	.DESCRIPTION
		Get the date and time of the most recent Azure Automation Runbook job execution
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER RunbookName
		Name of runbook to query last job execution
	.EXAMPLE
		Get-AzToolsAutomationLastJob -RunbookName "Get-MachinesByTag"
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationLastJob.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Runbook Name")]
			[string]$RunbookName,
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($global:AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				if (!$global:AzToolsLastRunbook -or $SelectContext) { Select-AzToolsAutomationRunbook }
				if ($global:AzToolsLastRunbook) {
					$params = @{
						ResourceGroupName     = $rgname
						AutomationAccountName = $aaname
						RunbookName           = $global:AzToolsLastRunbook.Name
					}
					Write-Host "Requesting jobs history for runbook: $($params.RunbookName) ..."
					$Jobs = Get-AzAutomationJob @params
					$Last = $Jobs | Sort-Object LastModifiedTime | Select-Object -ExpandProperty LastModifiedTime -Last 1
					[pscustomobject]@{
						RunbookName       = $params.RunbookName
						AutomationAccount = $params.AutomationAccountName
						ResourceGroup     = $params.ResourceGroupName
						LastJobRun        = $Last.LocalDateTime
					}
				}
			} else {
				Write-Warning "Automation Account not yet selected"
			}
		} else {
			Write-Warning "Resource Group not yet selected"
		}
	} else {
		Write-Warning "Azure Subscription not yet selected"
	}
}