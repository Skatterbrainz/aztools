function Remove-AzToolsContext {
	<#
	.SYNOPSIS
		Remove selected Azure Az Context sessions
	.DESCRIPTION
		Remove select Azure AzContext sessions for current user
	.PARAMETER NoConfirm
		Do not prompt for confirmation on each selectec context
	.EXAMPLE
		Remove-AzToolsContext
		Displays a gridview to select context objects to remove, then prompts for confirmation on each before removing
	.EXAMPLE
		Remove-AzToolsContext -NoConfirm
		Displays a gridview to select context objects to remove, then removes each without confirmation
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Remove-AzToolsContext.md
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$NoConfirm
	)
	$CurrentContextName = $(Get-AzContext | Select-Object -ExpandProperty Name)
	Write-Host "Current Az Context: $CurrentContextName" -ForegroundColor Cyan
	$contexts = Get-AzContext -ListAvailable | Where-Object {$_.Name -ne $CurrentContextName} |
		Sort-Object Name | Out-GridView -Title "Select Contexts to Remove" -OutputMode Multiple
	foreach ($ctx in $contexts) {
		if (!$NoConfirm) {
			if ((Read-Host -Prompt "Are you sure? <Y/n>") -eq 'Y') {
				Remove-AzContext -InputObject $ctx
				Write-Host "Context removed: $($ctx.Name)" -ForegroundColor Yellow
			}
		} else {
			Remove-AzContext -InputObject $ctx
			Write-Host "Context removed: $($ctx.Name)" -ForegroundColor Yellow
		}
	}
}