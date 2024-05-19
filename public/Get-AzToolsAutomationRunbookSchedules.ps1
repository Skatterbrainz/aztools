function Get-AzToolsAutomationRunbookSchedules {
	<#
	.SYNOPSIS
		Get Azure Automation Runbooks with an assigned Schedule
	.DESCRIPTION
		Get and/or export Azure Automation Runbooks with an assigned Schedule
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Get-AzToolsAutomationRunbookSchedules
		Returns all runbooks in the active Automation Account with an assigned Schedule
	.EXAMPLE
		Get-AzToolsAutomationRunbookSchedules -SelectContext
		Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
		returns all runbooks in the selected Automation Account with an assigned ScheduleName
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbookSchedules.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
		[switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		Write-Verbose "Subscription: $($AzToolsLastSubscription.Id) - $($AzToolsLastSubscription.Name)"
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			Write-Verbose "Resource group: $AzToolsLastResourceGroup"
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				$schedules = Get-AzAutomationSchedule -ResourceGroupName $rgname -AutomationAccountName $aaname | Sort-Object Name
				foreach ($schedule in $schedules) {
					$srbs = Get-AzAutomationScheduledRunbook -ResourceGroupName $rgname -AutomationAccountName $aaname -ScheduleName $schedule.Name | Sort-Object RunbookName
					$srbs | Select-Object RunbookName,ScheduleName,HybridWorker,ResourceGroupName,JobScheduleId
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