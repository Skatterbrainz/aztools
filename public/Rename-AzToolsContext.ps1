function Rename-AzToolsContext {
	<#
	.SYNOPSIS
		Rename an existing Azure context
	.DESCRIPTION
		Rename a selected Azure context for easier referencing
	.PARAMETER (none)
		This function requires no input
	.EXAMPLE
		Rename-AzToolsContext
		Displays gridview to select context to rename, then prompts for new name to apply
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Rename-AzToolsContext.md
	#>
	[CmdletBinding()]
	param ()
	Write-Host "Current Az Context: $(Get-AzContext | Select-Object -ExpandProperty Name)" -ForegroundColor Cyan
	$ctx = Get-AzContext -ListAvailable | Sort-Object Name | Out-GridView -Title "Select Profile to Rename" -OutputMode Single
	$newname = Read-Host -Prompt "New Name"
	if (![string]::IsNullOrWhiteSpace($newname)) {
		Rename-AzContext -InputObject $ctx -TargetName $newname -Scope CurrentUser
		Write-Host "Context renamed to: $($newname)" -ForegroundColor Yellow
	}
}