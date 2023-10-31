function Get-AzToolsAutomationJobs {
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
		Optional. Filter jobs starting after [StartTime] (date and time)
	.PARAMETER EndTime
		Optional. Filter jobs with status prior to [EndTime] (date and time)
	.PARAMETER RunbookName
		Optional. Filter jobs related to a specific Runbook
	.PARAMETER ShowOutput
		Optional. Send Jobs to Get-AzToolsJobOutput for more detailed information
	.PARAMETER ShowLimit
		Optional. Limit number of jobs to show when using -ShowOutput
		Default = 10
	.PARAMETER StopProcessing
		Optional. Stops jobs returned from query [only if] the JobStatus parameter is "Suspended"
	.EXAMPLE
		Get-AzToolsAutomationJobs -JobStatus Failed
	.EXAMPLE
		Get-AzToolsAutomationJobs -JobStatus Failed -RunbookName "MyRunbook"
	.EXAMPLE
		Get-AzToolsAutomationJobs -JobStatus Suspended -RunbookName "MyRunbook" -StopProcessing
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobs.md
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
		[parameter()][int]$ShowLimit = 10,
		[parameter()][switch]$StopProcessing
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
				if (!$global:AzToolsLastRunbook -or $SelectContext) { Select-AzToolsAutomationRunbook }
				if ($global:AzToolsLastRunbook) {
					$params = @{
						ResourceGroupName     = $rgname
						AutomationAccountName = $aaname
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
					} if ($StopProcessing) {
						if ($JobStatus -in ('Suspended')) {
							$counter = 1
							$total = $results.Count
							$results | Foreach-Object {
								try {
									Stop-AzAutomationJob -Id $_.JobId -ResourceGroupName $_.ResourceGroupName -AutomationAccountName $_.AutomationAccountName -ErrorAction Stop
									Write-Host "Stopped Job $counter of $total : $($_.JobId)"
								} catch {
									Write-Warning "Job Stop request $counter of $total failed. Error: $($_.Exception.Message)"
								}
								$counter++
							}
						}
					} else {
						$results
					}
				} else {
					Write-Warning "Runbook not yet selected"
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