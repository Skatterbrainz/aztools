function Get-AzAaJobs {
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
	if ($SelectContext) {
		Switch-AzContext
	}
	if (!$global:AztoolsLastSubscription -or $SelectContext) {
		$azsubs = Get-AzSubscription
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$global:AztoolsLastSubscription = $azsub
		}
	}
	if ($global:AztoolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) {
			$rglist = Get-AzResourceGroup
			if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
				$global:AzToolsLastResourceGroup = $rg
			}
		}
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) {
				if ($aalist = Get-AzAutomationAccount -ResourceGroupName $global:AzToolsLastResourceGroup.ResourceGroupName) {
					if ($aa = $aalist | Select-Object AutomationAccountName,ResourceGroupName | Out-GridView -Title "Select Automation Account" -OutputMode Single) {
						$global:AzToolsLastAutomationAccount = $aa
					}
				}
			}
			if ($global:AzToolsLastAutomationAccount) {
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($AzToolsLastAutomationAccount.AutomationAccountName)"
				$params = @{
					Status = $JobStatus
					ResourceGroupName = $global:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
				}
				if ($StartTime) { $params['StartTime'] = $StartTime }
				if ($EndTime) { $params['EndTime'] = $EndTime }
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