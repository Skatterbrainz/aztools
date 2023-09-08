function Update-AzToolsAutomationModule {
	<#
	.SYNOPSIS
		Update PowerShell module in Azure Automation Account
	.DESCRIPTION
		Update PowerShell module in Azure Automation Account
	.PARAMETER Name
		Required. Name of PowerShell Module
	.PARAMETER UpdateModule
		Optional. Force update of module (safety switch)
		Default (if not used) is to show current and latest versions for comparison only (no changes/updates applied)
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Update-AzToolsAutomationModule -Name ExchangeOnlineManagement
	.EXAMPLE
		Update-AzToolsAutomationModule -Name ExchangeOnlineManagement -UpdateModule
	.NOTES
		This function is heavily adapted from code written by Matthew Dowst (@mdowst), I just made miniscule tweaks to fit this module
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory)][string]$Name,
		[parameter()][switch]$UpdateModule,
		[parameter()][switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	$params = @{
		ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
		AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
		Name        = $Name
		ErrorAction = 'SilentlyContinue'
	}
	$aaModules = Get-AzAutomationModule @params
	if (!$aaModules) {
		Write-Host "$($Name) module is not installed in this Automation Account" -ForegroundColor Yellow
	} else {
		foreach ($aaModule in $aaModules) {
			#$AzModule = 'Az.' + $aaModule.Name.Split('.')[1]
			$UploadModules = Get-AzToolsAutomationModuleDetails $aaModule.Name
			if (-not $UploadModules){
				Write-Host "No module found for $($aaModule.Name) in PowerShellGallery" -ForegroundColor Red
			} else {
				$UploadModules | Foreach-Object {
					if (Invoke-AzToolsModuleVersionCheck -ModuleName $_.Name -MinimumVersion $_.Version) {
						Write-Host "$($_.Name) module is already present with an equal or higher version. No update required" -ForegroundColor Cyan
					} else {
						if ($UpdateModule) {
							Import-ModuleFromGallery -Module $_
						} else {
							Write-Host "$($_.Name) module has a new version available in PSGallery!" -ForegroundColor Yellow
						}
					}
				}
			}
		}
	}
}