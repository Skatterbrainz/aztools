function Get-AztJobOutput {
	[CmdletBinding()]
	param (
		[parameter(Mandatory)][string]$JobId,
		[parameter()][switch]$SelectContext
	)
	if ($SelectContext) {
		Switch-AztContext
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
					Id = $JobId
					Stream = 'Any'
				}
				$joboutput = Get-AzAutomationJobOutput @params | Where-Object {$_.Summary}
				if ($joboutput.Count -gt 0) {
					Write-Host "$($joboutput.Count) job output records found for Job: $JobId" -ForegroundColor Cyan
					$index = 1; $total = $joboutput.Count
					foreach ($item in $joboutput) {
						Write-Host "## Job output record: $index of $total"
						$params = @{
							JobId = $JobId
							Id = $item.StreamRecordId
							ResourceGroupName = $item.ResourceGroupName
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