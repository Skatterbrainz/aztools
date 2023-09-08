function Get-AzToolsRunbook {
	<#
	.SYNOPSIS
		Get Azure Automation Runbooks
	.DESCRIPTION
		Get Azure Automation Runbooks
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Filter
		Optional. Filter runbooks by name pattern.
		Default = "*" (all matching)
	.PARAMETER TagName
		Optional. Name of Tag to filter results.
	.PARAMETER TagValue
		Optional. If TagName is provided, filters the results to matching tag and value
		If not provided with TagName, then results are filtered to return runbooks
		which have Tag [TagName] regardless of the value assigned to the tag.
	.EXAMPLE
		Get-AzToolsRunbooks

		Returns all runbooks in the active Automation Account
	.EXAMPLE
		Get-AzToolsRunbooks -Filter "UserAccount*"

		Returns runbooks where the name begins with 'UserAccount'
	.EXAMPLE
		Get-AzToolsRunbooks -TagName "RunOn" -TagValue "Azure"

		Returns runbooks which have tag "RunOn" assigned to value "Azure"
	.EXAMPLE
		Get-AzToolsRunbooks -SelectContext

		Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
		returns all runbooks in the selected Automation Account.
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][string]$Filter = "*",
		[parameter()][string]$TagName,
		[parameter()][string]$TagValue
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		Write-Verbose "Subscription: $($AzToolsLastSubscription.Id) - $($AzToolsLastSubscription.Name)"
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			Write-Verbose "Resource group: $AzToolsLastResourceGroup"
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				$params = @{
					ResourceGroupName = $rgname
					AutomationAccountName = $aaname
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name #| Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if ($Filter -ne "*") {
					Write-Verbose "Filtering results on: $Filter"
					$runbooks = $runbooks | Where-Object { $_.Name -like $Filter }
				}
				if (![string]::IsNullOrWhiteSpace($TagName)) {
					Write-Verbose "Filtering results on: Tag=$TagName and Value=$TagValue"
					if (![string]::IsNullOrWhiteSpace($TagValue)) {
						$runbooks = $runbooks | Where-Object {$_.Tags[$TagName] -eq $TagValue}
					} else {
						$runbooks = $runbooks | Where-Object {$_.Tags[$TagName]}
					}
				}
				$runbooks
			} else {
				Write-Warning "Automation Account not yet selected"
			}
		} else {
			Write-Warning "Resource Group not yet selected"
		}
	} else {
		Write-Warning "Azure Subscription not yet selected"
	}
}