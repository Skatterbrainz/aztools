function Switch-AzToolsContext {
	<#
	.SYNOPSIS
		Switch between Azure Contexts
	.DESCRIPTION
		Switch between Azure contexts
	.PARAMETER Name
		Name of Context. If omitted, it will display a GridView to choose the target context
	.EXAMPLE
		Switch-AztContext
	.EXAMPLE
		Switch-AzToolsContext -name "contoso"
	.NOTES
	#>
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