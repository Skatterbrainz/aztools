function Get-AzToolsAutomationHybridWorker {
	<#
	.SYNOPSIS
		Get Automation Account Hybrid Worker status
	.DESCRIPTION
		Get Azure Automation Account Hybrid Workers and their current status.
		Only returns User hybrid workers (not system)
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER SelectAutomationAccount
		Optional. Prompt to select the Automation Account
	.PARAMETER ThresholdMinutes
		Optional. Number of minutes to allow for last-seen time before considering it a concern.
		Default is 30 minutes.
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker -SelectContext
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker -SelectAutomationAccount
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$SelectAutomationAccount,
		[parameter()][int]$ThresholdMinutes = 30
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) {
		$azsubs = Get-AzSubscription
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$global:AzToolsLastSubscription = $azsub
		}
	}
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext -or $SelectAutomationAccount) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				Write-Host "Select hybrid worker group" -ForegroundColor Cyan
				$params = @{
					ResourceGroupName = $AzToolsLastAutomationAccount.ResourceGroupName
					AutomationAccountName = $AzToolsLastAutomationAccount.AutomationAccountName
					ErrorAction = 'Stop'
				}
				$hwg = Get-AzAutomationHybridRunbookWorkerGroup @params | Where-Object {$_.GroupType -eq 'User'} | Sort-Object Name
				if ($hwg) {
					$hwx = $hwg | Select-Object Name, @{l='AutomationAccount';e={$global:AzToolsLastAutomationAccount.AutomationAccountName}} | Out-GridView -Title "Select Hybrid Worker Group" -OutputMode Single
					if ($hwx) {
						$params = @{
							HybridRunbookWorkerGroupName = $hwx.Name
							ResourceGroupName = $AzToolsLastAutomationAccount.ResourceGroupName
							AutomationAccountName = $AzToolsLastAutomationAccount.AutomationAccountName
						}
						$hw = Get-AzAutomationHybridRunbookWorker @params | Select-Object WorkerName,WorkerType,@{l='LastSeen';e={$_.LastSeenDateTime.LocalDateTime}},RegisteredDateTime,Ip,Id
						if ($hw.LastSeen -lt (Get-Date).AddMinutes(-$ThresholdMinutes)) {
							$stat = "More than $ThresholdMinutes minutes ago"
						} else {
							$stat = "Current"
						}
						$hw | Select-Object -Property *,@{l='Status';e={$stat}}
					}
				} else {
					Write-Host "No user hybrid worker groups were found" -ForegroundColor Yellow
				}
			}
		}
	}
}