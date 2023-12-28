function Select-AzToolsAutomationRunbook {
	[CmdletBinding()]
	param()
	Write-Verbose "Getting all runbooks in active Automation Account"
	$params = @{
		ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
		AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
	}
	$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
	Write-Host "Select: Automation Account Runbook" -ForegroundColor Cyan
	if (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
		if ($runbook = $runbooks | Out-ConsoleGridView -Title "Select Runbook" -OutputMode Single) {
			$global:AzToolsLastRunbook = $runbook
			$global:AzToolsLastRunbook
		}
	} else {
		if ($runbook = $runbooks | Out-GridView -Title "Select Runbook" -OutputMode Single) {
			$global:AzToolsLastRunbook = $runbook
			$global:AzToolsLastRunbook
		}
	}
}