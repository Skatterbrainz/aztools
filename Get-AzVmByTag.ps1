function Get-AzVmByTag {
	[CmdletBinding()]
	param (
		[parameter()][string]$TagName = 'PatchGroup',
		[parameter()][string]$TagValue = 'Group1'
	)
	[array]$azsubs = (Get-AzSubscription)
	foreach ($azsub in $azsubs) {
		Write-Verbose "subscription: $($azsub.Name) - $($azsub.Id)"
		$null = Select-AzSubscription -Subscription $azsub
		$machines = $null
		[array](Get-AzVm -Status | Where-Object {$_.Tags[$TagName] -eq $TagValue})
	}
}