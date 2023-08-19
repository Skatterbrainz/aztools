function Get-AzToolsRunbook {
	<#
	.SYNOPSIS
		Get Azure Automation Runbooks
	.DESCRIPTION
		Get Azure Automation Runbooks
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER All
		Optional. Return all runbooks in the current Automation Account
	.PARAMETER Filter
		Optional. Filter runbooks by name pattern.
		Default = "*" (all matching)
	.EXAMPLE
		Get-AzToolsRunbooks -All
	.EXAMPLE
		Get-AzToolsRunbooks -All -Filter "UserAccount*" -Path "c:\temp"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$All,
		[parameter()][string]$Filter = "*"
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$script:AzToolsLastSubscription -or $SelectContext) {
		$azsubs = Get-AzSubscription
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$script:AzToolsLastSubscription = $azsub
		}
	}
	if ($script:AzToolsLastSubscription) {
		if (!$script:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($script:AzToolsLastResourceGroup) {
			if (!$script:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($script:AzToolsLastAutomationAccount) {
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($script:AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($script:AzToolsLastAutomationAccount.AutomationAccountName)"
				$params = @{
					ResourceGroupName = $script:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $script:AzToolsLastAutomationAccount.AutomationAccountName
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name #| Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if ($Filter -ne "*") {
					$runbooks = $runbooks | Where-Object { $_.Name -like $Filter }
				}
				$runbooks
			}
		}
	}
}