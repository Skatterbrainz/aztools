function Export-AzAaRunbooks {
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$All,
		[parameter()][string]$Filter = "*",
		[parameter()][string]$Path = "$($env:USERPROFILE)\desktop"
	)
	if ($SelectContext) {
		Switch-AzContext
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
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if ($Filter -ne "*") {
					$runbooks = $runbooks | Where-Object { $_.Name -like $Filter }
				}
				foreach ($runbook in $runbooks) {
					Write-Host "Exporting: $(Join-Path $Path $runbook.Name)" -ForegroundColor Cyan
					$params = @{
						Name = $runbook.Name
						OutputFolder = $Path
						ResourceGroupName = $global:AzToolsLastResourceGroup.ResourceGroupName
						AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
						Force = $True
					}
					$null = Export-AzAutomationRunbook @params
				}
				Write-Host "$($runbooks.Count) runbooks were exported to: $Path" -ForegroundColor Green
			}
		}
	}
}