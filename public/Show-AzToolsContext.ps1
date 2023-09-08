function Show-AzToolsContext {
	[CmdletBinding()]
	param()
	Get-AzContext -ListAvailable | Sort-Object Name
	Write-Host "Current context: $(Get-AzContext | Select-Object -ExpandProperty Name)" -ForegroundColor Cyan
}