function Get-AzToolsMachines {
	[CmdletBinding()]
	param(
		[parameter()][switch]$SelectSubscription
	)
	Write-Verbose "Getting all active subscriptions"
	$azsubs = Get-AzSubscription | Where-Object {$_.State -eq 'Enabled'} | Select-Object Name,Id
	if ($SelectSubscription) {
		$azsubs = $azsubs | Out-GridView -Title "Select Subscriptions to Query" -OutputMode Multiple
	} else {
		Write-Host "Getting machines in $($azsubs.Count) active subscriptions"
	}
	Write-Verbose "Saving current AzContext"
	$ctx = Get-AzContext
	$result = @()
	Write-Host "Getting machines from $($azsubs.Count) subscriptions..." -ForegroundColor Cyan
	foreach ($azsub in $azsubs) {
		Set-AzContext -SubscriptionObject $azsub
		try {
			$machines = Get-AzVm -Status -ErrorAction Stop | Select-Object -Property Name,PowerState,OsName,ResourceGroupName,Location,Id,@{l='SubscriptionId';e={$azsub.Id}}
			Write-Host "$($azsub.Name) - machines: $($machines.count)" -ForegroundColor Cyan
			$result += $machines
		} catch {
			Write-Warning "Error: $($_.Exception.Message)"
		}
	}
	if ($ctx.Name -ne (Get-AzContext).Name) {
		Write-Verbose "Restoring original AzContext"
		Set-AzContext $ctx
	}
	$result
}