function Get-AzToolsModule {
	<#
	.SYNOPSIS
		Get Azure Automation Account Modules
	.DESCRIPTION
		Returns module names and versions for a selected Azure Automation Account
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER SelectAutomationAccount
		Optional. Prompt to select the Automation Account
	.EXAMPLE
		Get-AzToolsModule
	.EXAMPLE
		Get-AzToolsModule -SelectContext
	.EXAMPLE
		Get-AzToolsModule -SelectAutomationAccount
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$SelectAutomationAccount
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
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($AzToolsLastAutomationAccount.AutomationAccountName)"
				Get-AzAutomationModule -ResourceGroupName $global:AzToolsLastResourceGroup.ResourceGroupName -AutomationAccountName $global:AzToolsLastAutomationAccount.AutomationAccountName |
					Select Name,Version | Sort-Object Name
			}
		}
	}
}