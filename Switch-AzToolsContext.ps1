function Switch-AzToolsContext {
	<#
	.SYNOPSIS
		Switch between Azure Contexts
	.DESCRIPTION
		Switch between Azure contexts
	.PARAMETER Name
		Name of Context. If omitted, it will display a GridView to choose the target context
	.PARAMETER List
		List all defined Az Contexts on current system/session
	.EXAMPLE
		Switch-AztContext
	.EXAMPLE
		Switch-AzToolsContext -name "contoso"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][string]$Name,
		[parameter()][switch]$List
	)
	Write-Host "Current Az Context: $(Get-AzContext | Select-Object -ExpandProperty Name)" -ForegroundColor Cyan
	$ctx = $null
	if ([string]::IsNullOrWhiteSpace($Name)) {
		if ($List) {
			Get-AzContext -ListAvailable | Sort-Object Name
		} else {
			$ctx = Get-AzContext -ListAvailable | Sort-Object Name | Out-GridView -Title "Select Profile" -OutputMode Single
			if ($ctx) {
				Write-Host "Setting active context to: $($ctx.Name)" -ForegroundColor Yellow
				Set-AzContext $ctx
			}
		}
	} else {
		$ctx = Get-AzContext -ListAvailable | Where-Object {$_.Name -eq $Name}
		if ($ctx) {
			Write-Host "Setting active context to: $($ctx.Name)" -ForegroundColor Yellow
			Set-AzContext $ctx
		}
	}
	
}