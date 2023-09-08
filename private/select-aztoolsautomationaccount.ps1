function Select-AzToolsAutomationAccount {
	[CmdletBinding()]
	param ()
	if ($global:AzToolsLastResourceGroup) {
		Write-Verbose "Getting Automation Accounts in Resource Group: $($global:AzToolsLastResourceGroup.ResourceGroupName)"
		if ($aalist = Get-AzAutomationAccount -ResourceGroupName $global:AzToolsLastResourceGroup.ResourceGroupName) {
			Write-Host "Select: Automation Account" -ForegroundColor Cyan
			if ($aa = $aalist | Select-Object AutomationAccountName,ResourceGroupName | Out-GridView -Title "Select Automation Account" -OutputMode Single) {
				$global:AzToolsLastAutomationAccount = $aa
			}
		} else {
			Write-Warning "No Automation Accounts found in Resource Group: $($global:AzToolsLastResourceGroup.ResourceGroupName)"
		}
	} else {
		Write-Warning "Resource Group not yet selected"
	}
}
