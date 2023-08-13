function Get-AztStorageUsage {
	<#
	.SYNOPSIS
		Get Azure Storage Account summary information
	.DESCRIPTION
		Get Azure Storage Account container size and space used
	.PARAMETER Name
		Optional. Name of Storage Account
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Scope
		Optional. Limit search to either Current Subscription or All Subscription (within the tenant)
		Default = CurrentSubscription
	.EXAMPLE
		Get-AztStorageUsage -Scope AllSubscriptions
	.EXAMPLE
		Get-AztStorageUsage -Name "sa123456xyz"
	.NOTES
	#>
	[CmdletBinding()]
	param (
		[parameter()][string]$Name = "",
		[parameter()][switch]$SelectContext,
		[parameter()][string][ValidateSet('CurrentSubscription','AllSubscriptions')]$Scope = 'CurrentSubscription'
	)
	if ($SelectContext) {
		Switch-AztContext
	}
	try {
		$accounts = @()
		$context = Get-AzContext
		foreach ($azsub in (Get-AzSubscription -WarningAction SilentlyContinue)) {
			Write-Host "Checking subscription: $($azsub.Id) - $($azsub.Name)"
			try {
				$null = Set-AzContext $azsub
				$accounts += Get-AzStorageAccount
			} catch {
				Write-Warning "Subscription error: $($_.Exception.Message -join ';')"
			}
		}
		if (![string]::IsNullOrWhiteSpace($Name)) {
			$accounts = @($accounts | Where-Object {$_.StorageAccountName -eq $Name})
		}
		foreach ($account in $accounts) {
			$id  = $account.Id
			$sub = $($id -split '/')[2]
			try {
				$stMetric = Get-AzMetric -ResourceId $id -MetricName 'UsedCapacity' -ErrorAction Stop -WarningAction SilentlyContinue
				$usedCap  = $stMetric.Data
				$usedMB   = [math]::Round($usedCap.Average / 1MB, 2)
				$statmsg  = "success"
			} catch {
				$usedMB   = $null
				$statmsg  = "accessdenied"
			}
			[pscustomobject]@{
				StorageAccountName = $account.StorageAccountName
				StorageAccountId   = $id
				StorageSKU         = $account.Sku.Name
				ResourceGroup      = $account.ResourceGroupName
				Subscription       = $sub
				UsedSpaceMB        = $usedMB
				Message            = $statmsg
			}
		}
	} catch {
		Write-Warning "Error: $($_.Exception.Message)"
	} finally {
		$null = Set-AzContext $context
	}
}