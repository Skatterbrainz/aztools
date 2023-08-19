function Get-AzToolsRunbookJobs {
	<#
	.SYNOPSIS
		Get Azure Automation Account runbook jobs
	.DESCRIPTION
		Get Azure Automation Account runbook jobs
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER JobStatus
		Optional. Job Status type:
		Activating, Completed, Failed,Queued,Resuming, Running, Starting, Stopped, Stopping, Suspended, Suspending
		Default = Running
	.PARAMETER StartTime
	.PARAMETER EndTime
	.PARAMETER RunbookName
	.PARAMETER ShowOutput
		Optional. Send Jobs to Get-AzToolsJobOutput for more detailed information
	.PARAMETER ShowLimit
		Optional. Limit number of jobs to show when using -ShowOutput
		Default = 10
	.EXAMPLE
		Get-AzToolsRunbookJobs -JobStatus Failed
	.EXAMPLE
		Get-AzToolsRunbookJobs -JobStatus Failed -RunbookName "MyRunbook"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][string]
		[ValidateSet('Activating','Completed','Failed','Queued','Resuming','Running','Starting','Stopped','Stopping','Suspended','Suspending')]$JobStatus = 'Running',
		[parameter()][datetime]$StartTime,
		[parameter()][datetime]$EndTime,
		[parameter()][string]$RunbookName,
		[parameter()][switch]$ShowOutput,
		[parameter()][int]$ShowLimit = 10
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) {
		$azsubs = Get-AzSubscription
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$global:AzToolsLastSubscription = $azsub
		}
	}
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($global:AzToolsLastSubscription.Id) ResourceGroup=$($global:AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($global:AzToolsLastAutomationAccount.AutomationAccountName)"
				$params = @{
					ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
				}
				if (!$global:AzToolsLastRunbook -or $SelectContext) { Select-AzToolsAutomationRunbook }
				if ($global:AzToolsLastRunbook) {
					$params = @{
						ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
						AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
						RunbookName           = $($global:AzToolsLastRunbook).Name
					}
					if ($StartTime) { $params['StartTime'] = $StartTime }
					if ($EndTime)   { $params['EndTime']   = $EndTime }
					if ($JobStatus) { $params['Status']    = $JobStatus }
					Write-Host "Requesting job history for runbook: $($($global:AztoolsLastRunbook).Name)" -ForegroundColor Cyan
					$results = Get-AzAutomationJob @params | Sort-Object Time -Descending
					if ($ShowOutput) {
						Write-Host "Returned $($results.Count) jobs (limiting to $ShowLimit latest jobs)" -ForegroundColor Cyan
						if ($ShowLimit -gt 0) {
							$results | Select-Object -First $ShowLimit | Foreach-Object { Get-AzToolsJobOutput -JobId $_.JobId }
						} else {
							$results | Foreach-Object { Get-AzToolsJobOutput -JobId $_.JobId }
						}
					} else {
						$results
					}
				}
			}
		}
	}
}