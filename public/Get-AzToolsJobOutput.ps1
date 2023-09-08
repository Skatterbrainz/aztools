function Get-AzToolsJobOutput {
	<#
	.SYNOPSIS
		Get Azure Automation runbook job output
	.DESCRIPTION
		Get Azure Automation runbook job output
	.PARAMETER JobId
		Required. Automation Job ID
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Get-AztJobOutput -JobID abcdbf6d-1234-abcd-efgh-a5633676041c
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory)][string]$JobId,
		[parameter()][switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($global:AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				$params = @{
					ResourceGroupName     = $rgname
					AutomationAccountName = $aaname
					Id                    = $JobId
					Stream                = 'Any'
				}
				$joboutput = Get-AzAutomationJobOutput @params | Where-Object {$_.Summary}
				if ($joboutput.Count -gt 0) {
					Write-Host "$($joboutput.Count) job output records found for Job: $JobId" -ForegroundColor Cyan
					$index = 1; $total = $joboutput.Count
					foreach ($item in $joboutput) {
						Write-Host "## Job output record: $index of $total"
						$params = @{
							JobId                 = $JobId
							Id                    = $item.StreamRecordId
							ResourceGroupName     = $item.ResourceGroupName
							AutomationAccountName = $item.AutomationAccountName
						}
						Get-AzAutomationJobOutputRecord @params
						# Fields: JobId, StreamRecordId, Time, Summary, Value, Type, ResourceGroupName, AutomationAccountName
						$index++
					}
				} else {
					Write-Host "No job output records found which contain Summary data" -ForegroundColor Magenta
				}
			}
		}
	}
}