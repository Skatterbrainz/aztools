function Switch-AztContext {
	[CmdletBinding()]
	param (
		[parameter()][string]$Name = ""
	)
	if ([string]::IsNullOrWhiteSpace($Name)) {
		$ctx = Get-AzContext -ListAvailable | Sort-Object Name | Out-GridView -Title "Select Profile" -OutputMode Single
	} else {
		$ctx = Get-AzContext -ListAvailable | Where-Object {$_Name -eq $Name}
	}
	if ($ctx) { Set-AzContext $ctx }
}