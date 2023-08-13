function Get-AztModules {
	<#
	.SYNOPSIS
		Get Azure Automation Account Modules
	.DESCRIPTION
		Returns module names and versions for a selected Azure Automation Account
	.PARAMETER SelectContext
		Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Get-AztModules
	.NOTES
	#>
	[CmdletBinding()]
	param (
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
				Get-AzAutomationModule -ResourceGroupName $global:AzToolsLastResourceGroup.ResourceGroupName -AutomationAccountName $global:AzToolsLastAutomationAccount.AutomationAccountName |
					Select Name,Version | Sort-Object Name
			}
		}
	}
}