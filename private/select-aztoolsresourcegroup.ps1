function Select-AzToolsResourceGroup {
	[CmdletBinding()]
	param()
	if ($global:AzToolsLastSubscription) {
		if ((Get-AzContext).Subscription.Id -ne $AzToolsLastSubscription.Id) {
			$null = Set-AzContext -Subscription $AzToolsLastSubscription.Id
		}
		Write-Verbose "Getting resource groups"
		$rglist = Get-AzResourceGroup
		Write-Host "Select: Resource Group" -ForegroundColor Cyan
		if (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
			if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-ConsoleGridView -Title "Select Resource Group" -OutputMode Single) {
				$global:AzToolsLastResourceGroup = $rg
				Write-Host "Selected > $($rg.ResourceGroupName) in Location: $($rg.Location)" -ForegroundColor Cyan
			}
		} else {
			if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
				$global:AzToolsLastResourceGroup = $rg
				Write-Host "Selected > $($rg.ResourceGroupName) in Location: $($rg.Location)" -ForegroundColor Cyan
			}
		}
	} else {
		Write-Warning "Subscription not selected. Use Switch-AzToolsContext"
	}
}

