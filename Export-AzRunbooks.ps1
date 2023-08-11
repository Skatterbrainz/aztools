function Export-AzRunbooks {
	[CmdletBinding()]
	param (
		[parameter()][switch]$All,
		[parameter()][switch]$IncludeSamples,
		[parameter()][string]$Path = "$($env:USERPROFILE)\desktop"
	)
	$aa = Get-AzAutomationAccount | Sort-Object AutomationAccountName | Out-GridView -Title "Select Automation Account" -OutputMode Single
	if ($aa) {
		$runbooks = Get-AzAutomationRunbook -ErrorAction $aa.ResourceGroupName -AutomationAccountName $aa.AutomationAccountName | Sort-Object Name
		if (!$IncludeSamples) {
			$runbooks = $runbooks | Where-Object {$_.Name -notlike 'AzureAutomationTutorial*'}
		}
		if (!$All) {
			$runbooks = $runbooks | Out-GridView -Title "Select Runbooks" -OutputMode Multiple
		}
		foreach ($runbook in $runbooks) {
			Write-Host "Exporting: $(Join-Path $Path $runbook.Name)" -ForegroundColor Cyan
			$null = Export-AzAutomationRunbook -Name $runbook.Name -OutputFolder $Path -ResourceGroupName $aa.ResourceGroupName -AutomationAccountName $aa.AutomationAccount -Force
		}
		Write-Host "Exported $($runbooks.Count) runbooks" -ForegroundColor Cyan
	}
}