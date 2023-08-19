function Select-AzToolsResourceGroup {
	param()
	$rglist = Get-AzResourceGroup
	if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
		$script:AzToolsLastResourceGroup = $rg
	}
}

function Select-AzToolsAutomationAccount {
	param ()
	if ($aalist = Get-AzAutomationAccount -ResourceGroupName $script:AzToolsLastResourceGroup.ResourceGroupName) {
		if ($aa = $aalist | Select-Object AutomationAccountName,ResourceGroupName | Out-GridView -Title "Select Automation Account" -OutputMode Single) {
			$script:AzToolsLastAutomationAccount = $aa
		}
	}
}

function Select-AzToolsAutomationRunbook {
	param()
	$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
	if (!$global:AztoolsLastRunbook -or $SelectContext) {
		if ($runbook = $runbooks | Out-GridView -Title "Select Runbook" -OutputMode Single) {
			$script:AztoolsLastRunbook = $runbook
		}
	}
}

Function Get-AzToolsModuleDetails {
	<#
	.SYNOPSIS
		Get the module details from the PowerShell Gallery and returns any dependencies
	.PARAMETER ModuleName
		The name of the module to look up
	#>
	[CmdletBinding()]
	[OutputType([object])]
	param(
		[parameter(Mandatory=$true)][string]$ModuleName
	)
	$Module = Find-Module -Name $ModuleName
	$Module.Dependencies | ForEach-Object { Get-AzModuleDetails -ModuleName $_['Name'] }
	$Module
}

Function Get-ModuleVersionCheck {
	<#
	.SYNOPSIS
		Checks if the module already exists in the Automation Account and if it an equal or greater version
	.PARAMETER ModuleName
		The name of the module to check for
	.PARAMETER MinimumVersion
		The minimum required version of the module to check for
	#>
	[CmdletBinding()]
	[OutputType([boolean])]
	param (
		[parameter(Mandatory=$true)][string]$ModuleName,
		[parameter(Mandatory=$true)][string]$MinimumVersion
	)
	$params = @{
		ResourceGroupName = $script:AzToolsLastResourceGroup.ResourceGroupName
		AutomationAccountName = $script:AzToolsLastAutomationAccount.AutomationAccountName
		Name = $ModuleName
		ErrorAction = 'SilentlyContinue'
	}
	$ModuleCheck = Get-AzAutomationModule @params
	return $([version]$ModuleCheck.Version -ge [version]$MinimumVersion)
}

function Get-AzToolsContext {
	param()
	$res = $(
		[pscustomobject]@{
			Subscription   = (Get-AzContext).Subscription.Name
			SubscriptionID = (Get-AzContext).Subscription.Id
			ResourceGroupName = $($script:AzToolsLastResourceGroup | Select-Object -ExpandProperty ResourceGroupname)
			AutomationAccount = $($script:AzToolsLastAutomationAccount | Select-Object -ExpandProperty AutomationAccountName)
		}
	)
	$res | ConvertTo-Json
}

function Get-AzToolsLastContextItem {
	[CmdletBinding()]
	param (
		[parameter(Mandatory)][string][ValidateSet('Subscription','ResourceGroup','AutomationAccount','StorageAccount')]$ItemType
	)
	$filename = "aztools_current_$($ItemType).json"
	$filepath = Join-Path -Path "$($env:USERPROFILE)" -ChildPath "documents\$filename"
	if (Test-Path $filepath) {
		Get-Content -Path $filepath | ConvertFrom-Json
	}
}

function Set-AzToolsLastContextItem {
	[CmdletBinding()]
	param (
		[parameter(Mandatory)][string][ValidateSet('Subscription','ResourceGroup','AutomationAccount','StorageAccount')]$ItemType,
		[parameter(Mandatory)]$Value
	)
	$filename = "aztools_current_$($ItemType).json"
	$filepath = Join-Path -Path "$($env:USERPROFILE)" -ChildPath "documents\$filename"
	$Value | ConvertTo-Json | Out-File -FilePath $filepath -Force
}