function Get-AzToolsAutomationModule {
	<#
	.SYNOPSIS
		Get Azure Automation Account Modules
	.DESCRIPTION
		Returns module names and versions for a selected Azure Automation Account
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Get-AzToolsAutomationModule
	.EXAMPLE
		Get-AzToolsAutomationModule -SelectContext
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationModule.md
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				Get-AzAutomationModule -ResourceGroupName $rgname -AutomationAccountName $aaname | Select Name,Version | Sort-Object Name
			}
		}
	}
}