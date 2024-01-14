function Switch-AzToolsContext {
	<#
	.SYNOPSIS
		Switch between Azure Contexts
	.DESCRIPTION
		Switch between Azure contexts using a PowerShell Gridview menu
	.PARAMETER Name
		Name of Context. If omitted, it will display a GridView to choose the target context
	.PARAMETER List
		List all defined Az Contexts on current system/session
	.EXAMPLE
		Switch-AztContext
	.EXAMPLE
		Switch-AzToolsContext -name "contoso"
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Switch-AzToolsContext.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Context Name or blank to prompt for Selection using a GridView")]
			[string]$Name,
		[parameter(Mandatory=$False,HelpMessage="Show a list of all cached Azure connection context entries")]
			[switch]$List
	)
	$ctx = (Get-AzContext)
	if ($ctx) {
		Write-Host "Current Az Context: $($ctx.Name)" -ForegroundColor Cyan
	} else {
		Connect-AzAccount
	}
	$ctx = $null
	if ([string]::IsNullOrWhiteSpace($Name)) {
		if ($List) {
			Get-AzContext -ListAvailable | Sort-Object Name
		} else {
			$curctx = (Get-AzContext)
			if (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
				$ctx = Get-AzContext -ListAvailable | Sort-Object Name | Out-ConsoleGridView -Title "Select Profile" -OutputMode Single
			} else {
				$ctx = Get-AzContext -ListAvailable | Sort-Object Name | Out-GridView -Title "Select Profile" -OutputMode Single
			}
			if ($ctx) {
				if ($curctx.Name -ne $ctx.Name) {
					$global:AzToolsLastResourceGroup = $null
					$global:AzToolsLastAutomationAccount = $null
					$global:AzToolsLastRunbook = $null
				}
				Write-Host "Setting active context to: $($ctx.Name)" -ForegroundColor Yellow
				$global:AztoolsLastSubscription = $ctx.Subscription
				Set-AzToolsContext -Context $ctx
				#Set-AzContext $ctx
			}
		}
	} else {
		$ctx = Get-AzContext -ListAvailable | Where-Object {$_.Name -eq $Name}
		if ($ctx) {
			Write-Host "Setting active context to: $($ctx.Name)" -ForegroundColor Yellow
			$global:AztoolsLastSubscription = $ctx.Subscription
			#Set-AzContext $ctx
			Set-AzToolsContext -Context $ctx
		}
	}
}