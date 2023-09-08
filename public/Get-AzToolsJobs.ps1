function Get-AzToolsJobs {
	<#
	.SYNOPSIS
		Get Azure Automation Account Runbook Jobs
	.DESCRIPTION
		Get Azure Automation Account Runbook Jobs.
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER JobStatus
		Optional. Job status: Activating, Completed, Failed, Queued, Resuming, Running, Starting, Stopped, Stopping, Suspended, Suspending
		Default = Running
	.PARAMETER StartTime
		Optional. Limit results to jobs which have a StartTime >= date/time value
	.PARAMETER EndTime
		Optional. Limit results to jobs which have a EndTime <= date/time value
	.PARAMETER RunbookName
		Optional. Limit results to jobs related to named Runbook
	.PARAMETER HybridWorkerName
		Optional. Limit results to jobs related to named HybridWorker (group)
	.PARAMETER ShowOutput
		Optional. Send job output to Get-AztJobOutput for more details per each job
	.EXAMPLE
		Get-AzToolsJobs -JobStatus "Failed"
	.EXAMPLE
		Get-AzToolsJobs -StartTime "8/1/2023 12:00" -EndTime "8/2/2023 8:00" -RunbookName "MyRunbook" -HybridWorkerName "HwGroup1"
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
		[parameter()][string]$HybridWorkerName,
		[parameter()][switch]$ShowOutput
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($script:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext -or $SelectAutomationAccount) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				$params = @{
					Status                = $JobStatus
					ResourceGroupName     = $rgname
					AutomationAccountName = $aaname
				}
				if ($StartTime) { $params['StartTime'] = $StartTime }
				if ($EndTime)   { $params['EndTime']   = $EndTime }
				$results = Get-AzAutomationJob @params
				# Fields: JobId,CreationTime,Status,StatusDetails,StartTime,EndTime,Exception,
				#   JobParameters,RunbookName,HybridWorker,StartedBy,
				#   LastModifiedTime,LastStatusModifiedTime,ResourceGroupName,AutomationAccountName
				if ($HybridWorkerName) {
					if ($RunbookName) {
						$results = $results | Where-Object {$_.HybridWorker -eq $HybridWorkerName -and $_.RunbookName -eq $RunbookName}
					} else {
						$results = $results | Where-Object {$_.HybridWorker -eq $HybridWorkerName}
					}
				} elseif ($RunbookName) {
					$results = $results | Where-Object {$_.RunbookName -eq $RunbookName}
				}
				$results
			}
		}
	}
}