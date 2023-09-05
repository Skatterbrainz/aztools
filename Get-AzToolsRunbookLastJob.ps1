Function Get-AzToolsRunbookLastJob {
	[CmdletBinding()]
	param(
		[parameter()][string]$ResourceGroupName,
		[parameter()][string]$AutomationAccountName,
		[parameter()][string]$RunbookName
	)
	try {
		$Jobs = Get-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -RunbookName $RunbookName
		$Last = $Jobs | Sort-Object LastModifiedTime | Select-Object -ExpandProperty LastModifiedTime -Last 1
		$Last.LocalDateTime
	} catch {
		Write-Error $_.Exception.Message
	}
}