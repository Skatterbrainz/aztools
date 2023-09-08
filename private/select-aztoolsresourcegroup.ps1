function Select-AzToolsResourceGroup {
	[CmdletBinding()]
	param()
	Write-Verbose "Getting resource groups"
	$rglist = Get-AzResourceGroup
	Write-Host "Select: Resource Group" -ForegroundColor Cyan
	if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
		$global:AzToolsLastResourceGroup = $rg
	}
}

