function Get-AzToolsAutomationHybridWorker {
	<#
	.SYNOPSIS
		Get Automation Account Hybrid Worker status
	.DESCRIPTION
		Get Azure Automation Account Hybrid Workers and their current status.
		Only returns User hybrid workers (not system)
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER ThresholdMinutes
		Optional. Number of minutes to allow for last-seen time before considering it a concern.
		Default is 30 minutes.
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker -SelectContext
	.EXAMPLE
		Get-AzToolsAutomationHybridWorker -ThresholdMinutes 45
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationHybridWorker.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext,
		[parameter(Mandatory=$False,HelpMessage="Max minutes to consider hybrid worker is offline")]
			[int]$ThresholdMinutes = 30
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $AzToolsLastAutomationAccount.ResourceGroupName
				Write-Verbose "Getting hybrid worker groups"
				$params = @{
					ResourceGroupName     = $rgname
					AutomationAccountName = $aaname
					ErrorAction           = 'Stop'
				}
				Write-Verbose "Filtering on GroupType=User"
				$hwg = Get-AzAutomationHybridRunbookWorkerGroup @params | Where-Object {$_.GroupType -eq 'User'} | Sort-Object Name
				if ($hwg) {
					Write-Host "Select hybrid worker group" -ForegroundColor Cyan
					$hwx = $hwg | Select-Object Name, @{l='AutomationAccount';e={$aaname}} | Out-GridView -Title "Select Hybrid Worker Group" -OutputMode Single
					if ($hwx) {
						Write-Verbose "Getting hybrid worker details"
						$params = @{
							HybridRunbookWorkerGroupName = $hwx.Name
							ResourceGroupName            = $rgname
							AutomationAccountName        = $aaname
						}
						$hw = Get-AzAutomationHybridRunbookWorker @params | Select-Object WorkerName,WorkerType,@{l='LastSeen';e={$_.LastSeenDateTime.LocalDateTime}},RegisteredDateTime,Ip,Id
						Write-Verbose "Comparing last-seen datetime values"
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