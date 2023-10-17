function Get-AzToolsVm {
	<#
	.SYNOPSIS
		Get Azure Virtual Machines by searching on Tag name/value or Extension
	.DESCRIPTION
		Get Azure Virtual Machines by searching on Tag name/value or Extension
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER AllSubscriptions
		Optional. Enumerate machines in all subscriptions.
		Default = Enumerate machines in the current/active context subscription only.
	.PARAMETER TagName
		Optional. Tag name to search for
	.PARAMETER TagValue
		Required if -TagName is used. Value assigned to TagName to filter on
	.PARAMETER ExtensionName
		Optional. Name of Azure VM extension
	.PARAMETER SubscriptionId
		Optional. Limits scope to subscription with matching Id only.
		If AllSubscriptions is used, this is ignored.
	.EXAMPLE
		Get-AzToolsVm -TagName "PatchGroup" -TagValue "Group2"

		Returns all VM's in the current subscription which have tag "PatchGroup" assigned with value "Group2"
	.EXAMPLE
		Get-AzToolsVm -TagName "PatchGroup" -TagValue "Group2" -AllSubscriptions

		Returns all VM's in all subscriptions which have tag "PatchGroup" assign with value "Group2"
	.EXAMPLE
		Get-AzToolsVm -TagName "PatchGroup" -AllSubscriptions

		Returns all VM's in all subscriptions which have tag "PatchGroup" assigned with any value,
		sorted by tag value first, then by machine name
	.EXAMPLE
		Get-AzToolsVm -TagName "PatchGroup" -AllSubscription | Select-Object PatchGroup,Name,OSName,PowerState

		Example showing some common properties to return for viewing or processing, something like this:

		```
		PatchGroup Name               OsName                                       PowerState
		---------- ----               ------                                       ----------
		Group1     AZEVMCTXA01        Windows Server 2016 Standard                 VM running
		Group1     AZEVMCTXA03        Windows Server 2016 Datacenter               VM running
		Group1     AZEVMCTXDB02       Windows Server 2016 Standard                 VM running
		Group1     AZDEVCXDB04                                                     VM deallocated
		Group2     AZEPRODAW01        Windows Server 2016 Standard                 VM running
		Group2     AZEPRODAW02        Windows Server 2016 Datacenter               VM running
		Group2     AZEPRODDB01        Windows Server 2016 Datacenter               VM running
	```
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$true)][string]$TagName,
		[parameter(Mandatory=$false)][string]$TagValue = "",
		[parameter(Mandatory=$false)][switch]$SelectContext,
		[parameter(Mandatory=$false)][switch]$AllSubscriptions,
		[parameter(Mandatory=$false)][string]$SubscriptionId
	)
	if ($SelectContext) { Switch-AzToolsContext }
	try {
		$currentContext = (Get-AzContext)
		if ($AllSubscriptions) {
			[array]$azsubs = Get-AzSubscription | Where-Object {$_.State -eq 'Enabled'}
		} elseif (![string]::IsNullOrWhiteSpace($SubscriptionId)) {
			[array]$azsubs = Get-AzSubscription -SubscriptionId $SubscriptionId
		} else {
			[array]$azsubs = $(Get-AzContext).Subscription
		}
		$scount  = $azsubs.Count
		$counter = 1
		foreach ($azsub in $azsubs) {
			Write-Host "Subscription $counter of $scount : $($azsub.Name) - $($azsub.Id)" -ForegroundColor Cyan
			$null = Select-AzSubscription -Subscription $azsub
			$machines = $null
			if ([string]::IsNullOrWhiteSpace($TagValue)) {
				$machines = (Get-AzVm -Status | Where-Object {-not ([string]::IsNullOrWhiteSpace($_.Tags["$TagName"])) } | Select-Object -Property *,@{l="$TagName";e={$_.Tags["$TagName"]}},@{l='SubscriptionId';e={$azsub.Id}})
			} else {
				$machines = (Get-AzVm -Status | Where-Object {$_.Tags["$TagName"] -eq "$TagValue"} | Select-Object -Property *,@{l='SubscriptionId';e={$azsub.Id}})
			}
			$machines
			$counter++
		}
	} catch {}
	finally {
		if ($currentContext -ne (Get-AzContext)) {
			$null = Set-AzContext $currentContext
		}
	}
}