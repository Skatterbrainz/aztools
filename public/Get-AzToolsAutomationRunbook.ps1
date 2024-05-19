function Get-AzToolsAutomationRunbook {
	<#
	.SYNOPSIS
		Get Azure Automation Runbooks
	.DESCRIPTION
		Get and/or export Azure Automation Runbooks
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
	.PARAMETER Export
		Optional. Save runbooks to local path
	.PARAMETER ExportPath
		Optional. If -Export is used, specifies the path where runbook files will be saved.
		Default is current user profile "desktop" path.
	.EXAMPLE
		Get-AzToolsAutomationRunbook

		Returns all runbooks in the active Automation Account
	.EXAMPLE
		Get-AzToolsAutomationRunbook -Filter "UserAccount*"

		Returns runbooks where the name begins with 'UserAccount'
	.EXAMPLE
		Get-AzToolsAutomationRunbook -TagName "RunOn" -TagValue "Azure"

		Returns runbooks which have tag "RunOn" assigned to value "Azure"
	.EXAMPLE
		Get-AzToolsAutomationRunbook -SelectContext

		Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
		returns all runbooks in the selected Automation Account.
	.EXAMPLE
		Get-AzToolsAutomationRunbook -Export -ExportPath "c:\temp"

		Exports runbooks to files under "c:\temp"
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbook.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext,
		[parameter(Mandatory=$False,HelpMessage="Filter by Name or * for All Runbooks")]
			[string]$Filter = "*",
		[parameter(Mandatory=$False,HelpMessage="Filter by Azure Resource Tag Name")]
			[string]$TagName,
		[parameter(Mandatory=$False,HelpMessage="Filter by Azure Resource Tag Value")]
			[string]$TagValue,
		[parameter(Mandatory=$False,HelpMessage="Export Runbooks to local files")]
			[switch]$Export,
		[parameter(Mandatory=$False,HelpMessage="Path to Export Runbook files")]
			[string]$ExportPath = "$($env:USERPROFILE)\desktop"
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
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name
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
				if ($Export) {
					foreach ($runbook in $runbooks) {
						Write-Host "Exporting: $(Join-Path $ExportPath $runbook.Name)" -ForegroundColor Cyan
						$params = @{
							Name                  = $runbook.Name
							OutputFolder          = $ExportPath
							ResourceGroupName     = $rgname
							AutomationAccountName = $aaname
							Slot                  = "Published"
							Force                 = $True
						}
						$null = Export-AzAutomationRunbook @params
					}
				} else {
					$runbooks
				}
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