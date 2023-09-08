function Export-AzToolsRunbooks {
	<#
	.SYNOPSIS
		Export Azure Automation Runbooks to local storage
	.DESCRIPTION
		Export Azure Automation Runbooks to local storage
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Filter
		Optional. Filter runbooks by name pattern.
		Default = "*" (all matching)
	.PARAMETER Path
		Optional. Destination folder path.
		Default = current user Desktop
	.EXAMPLE
		Export-AzToolsRunbooks
	.EXAMPLE
		Export-AzToolsRunbooks -Filter "UserAccount*" -Path "c:\temp"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][string]$Filter = "*",
		[parameter()][string]$Path = "$($env:USERPROFILE)\desktop"
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AztoolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($AzToolsLastAutomationAccount.AutomationAccountName)"
				$params = @{
					ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if ($Filter -ne "*") {
					$runbooks = $runbooks | Where-Object { $_.Name -like $Filter }
				}
				if ($runbooks.Count -gt 0) {
					foreach ($runbook in $runbooks) {
						Write-Host "Exporting: $(Join-Path $Path $runbook.Name)" -ForegroundColor Cyan
						$params = @{
							Name                  = $runbook.Name
							OutputFolder          = $Path
							ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
							AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
							Force                 = $True
						}
						$null = Export-AzAutomationRunbook @params
					}
					Write-Host "$($runbooks.Count) runbooks were exported to: $Path" -ForegroundColor Green
				} else {
					Write-Host "No runbooks found for the current search criteria" -ForegroundColor Magenta
				}
			}
		}
	}
}