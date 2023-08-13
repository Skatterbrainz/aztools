function Get-AzAaRunbookJobs {
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
					ResourceGroupName = $global:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if (!$global:AztoolsLastRunbook -or $SelectContext) {
					if ($runbook = $runbooks | Out-GridView -Title "Select Runbook" -OutputMode Single) {
						$global:AztoolsLastRunbook = $runbook
					}
				}
				$params = @{
					ResourceGroupName = $global:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
					RunbookName = $($global:AztoolsLastRunbook).Name
				}
				if ($StartTime) { $params['StartTime'] = $StartTime }
				if ($EndTime) { $params['EndTime'] = $EndTime }
				if ($JobStatus) { $params['Status'] = $JobStatus }
				Write-Host "Requesting job history for runbook: $($($global:AztoolsLastRunbook).Name)" -ForegroundColor Cyan
				$results = Get-AzAutomationJob @params | Sort-Object Time -Descending
				if ($ShowOutput) {
					Write-Host "Returned $($results.Count) jobs (limiting to $ShowLimit latest jobs)" -ForegroundColor Cyan
					if ($ShowLimit -gt 0) {
						$results | Select-Object -First $ShowLimit | Foreach-Object { Get-AzAaJobOutput -JobId $_.JobId }
					} else {
						$results | Foreach-Object { Get-AzAaJobOutput -JobId $_.JobId }
					}
				} else {
					$results
				}
			}
		}
	}
}