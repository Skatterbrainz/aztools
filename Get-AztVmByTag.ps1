function Get-AztVmByTag {
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][string]$TagName = 'PatchGroup',
		[parameter()][string]$TagValue = 'Group1'
	)
	if ($SelectContext) {
		Switch-AztContext
	}
	[array]$azsubs = (Get-AzSubscription)
	foreach ($azsub in $azsubs) {
		Write-Host "Subscription: $($azsub.Name) - $($azsub.Id)" -ForegroundColor Cyan
		$null = Select-AzSubscription -Subscription $azsub
		$machines = $null
		[array](Get-AzVm -Status | Where-Object {$_.Tags[$TagName] -eq $TagValue})
	}
}