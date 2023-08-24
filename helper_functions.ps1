function Select-AzToolsResourceGroup {
	param()
	$rglist = Get-AzResourceGroup
	if ($rg = $rglist | Select-Object ResourceGroupName,Location | Out-GridView -Title "Select Resource Group" -OutputMode Single) {
		$global:AzToolsLastResourceGroup = $rg
	}
}

function Select-AzToolsAutomationAccount {
	param ()
	if ($aalist = Get-AzAutomationAccount -ResourceGroupName $global:AzToolsLastResourceGroup.ResourceGroupName) {
		if ($aa = $aalist | Select-Object AutomationAccountName,ResourceGroupName | Out-GridView -Title "Select Automation Account" -OutputMode Single) {
			$global:AzToolsLastAutomationAccount = $aa
		}
	}
}

function Select-AzToolsAutomationRunbook {
	param()
	$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name | Select-Object Name,RunbookType,Location,State,LastModifiedTime
	if (!$global:AzToolsLastRunbook -or $SelectContext) {
		if ($runbook = $runbooks | Out-GridView -Title "Select Runbook" -OutputMode Single) {
			$global:AzToolsLastRunbook = $runbook
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
		ResourceGroupName     = $global:AzToolsLastResourceGroup.ResourceGroupName
		AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
		Name                  = $ModuleName
		ErrorAction           = 'SilentlyContinue'
	}
	$ModuleCheck = Get-AzAutomationModule @params
	return $([version]$ModuleCheck.Version -ge [version]$MinimumVersion)
}

function Get-AzToolsContext {
	param()
	$res = $(
		[pscustomobject]@{
			Subscription      = (Get-AzContext).Subscription.Name
			SubscriptionID    = (Get-AzContext).Subscription.Id
			ResourceGroupName = $($global:AzToolsLastResourceGroup | Select-Object -ExpandProperty ResourceGroupname)
			AutomationAccount = $($global:AzToolsLastAutomationAccount | Select-Object -ExpandProperty AutomationAccountName)
		}
	)
	$res | ConvertTo-Json
}

function Get-AzToolsMachines {
	[CmdletBinding()]
	param(
		[parameter()][switch]$SelectSubscription
	)
	Write-Verbose "Getting all active subscriptions"
	$azsubs = Get-AzSubscription | Where-Object {$_.State -eq 'Enabled'} | Select-Object Name,Id
	if ($SelectSubscription) {
		$azsubs = $azsubs | Out-GridView -Title "Select Subscriptions to Query" -OutputMode Multiple
	} else {
		Write-Host "Getting machines in $($azsubs.Count) active subscriptions"
	}
	Write-Verbose "Saving current AzContext"
	$ctx = Get-AzContext
	$result = @()
	Write-Host "Getting machines from $($azsubs.Count) subscriptions..." -ForegroundColor Cyan
	foreach ($azsub in $azsubs) {
		Set-AzContext -SubscriptionObject $azsub
		try {
			$machines = Get-AzVm -Status -ErrorAction Stop | Select-Object -Property Name,PowerState,OsName,ResourceGroupName,Location,Id,@{l='SubscriptionId';e={$azsub.Id}}
			Write-Host "$($azsub.Name) - machines: $($machines.count)" -ForegroundColor Cyan
			$result += $machines
		} catch {
			Write-Warning "Error: $($_.Exception.Message)"
		}
	}
	if ($ctx.Name -ne (Get-AzContext).Name) {
		Write-Verbose "Restoring original AzContext"
		Set-AzContext $ctx
	}
	$result
}