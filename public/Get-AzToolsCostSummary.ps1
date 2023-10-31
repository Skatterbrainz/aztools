function Get-AzToolsCostSummary {
	<#
	.DESCRIPTION
	.PARAMETER SubscriptionID
		Optional.
	.PARAMETER StartDate
		Optional.
		Default = 7 days ago
	.PARAMETER EndDate
		Optional.
		Default = Current date
	.PARAMETER CostMetric
		PretaxCost or UsageQuantity
		Cost metric to sum for total estimate cost
		Default = UsageQuantity
	.NOTES
		I don't know. No matter what I throw at this I don't seem to get back numbers
		that match the portal. I've tried Get-AzBilling<abcdef> cmdlets also, but none
		seem to come close to the costs in the portal. Maybe I need to inhale more paint
		fumes or eat kitty litter or something.
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md
	#>
	[CmdletBinding()]
	param (
		[parameter()][string]$SubscriptionID,
		[parameter()][string]$StartDate = $((Get-Date).AddDays(-7).ToString('yyyy-MM-dd')),
		[parameter()][string]$EndDate = $(Get-Date).ToString('yyyy-MM-dd'),
		[parameter()][string][ValidateSet('PretaxCost','UsageQuantity')]$CostMetric = 'UsageQuantity'
	)
	try {
		Write-Verbose "Connecting to Azure..."
		if (![string]::IsNullOrWhiteSpace($SubscriptionID)) {
			[array]$azSubs = Get-AzSubscription -SubscriptionId $SubscriptionID
		} else {
			Write-Host "Getting active Subscriptions..." -ForegroundColor Cyan
			[array]$azSubs = Get-AzSubscription | Where-Object {$_.State -eq 'Enabled'}
		}
		$total = $azSubs.Count
		$counter = 1
		$curContext = Get-AzContext
		foreach ($azSub in $azSubs) {
			if ($azSub.Id -ne $curContext.Subscription.Id) {
				$null = Set-AzContext $azSub
			}
			Write-Host "Subscription $counter of $total : $($azSub.Id) - $($azSub.Name)" -ForegroundColor Cyan
			$cud = $null
			$cud = Get-AzConsumptionUsageDetail -StartDate $StartDate -EndDate $EndDate -Expand MeterDetails -ErrorAction SilentlyContinue
			if ($cud) {
				Write-Host "`tGetting ResourceTypes" -ForegroundColor Cyan
				$svcs = $cud |
					Select-Object AccountName,ConsumedService,SubscriptionGuid,SubscriptionName,IsEstimated,PretaxCost,UsageQuantity |
						Group-Object -Property ConsumedService | Select-Object Name,Count
				Write-Verbose "Calculating costs per resource type"
				$svcs | Foreach-Object {
					$svcName = $_.Name
					$svcQty  = $_.Count
					$instances = $cud | Where-Object {$_.ConsumedService -eq $svcName}
					$cost = $instances | Measure-Object -Property $CostMetric -Sum | Select-Object -ExpandProperty Sum
					[pscustomobject]@{
						Subscription    = "$($azSub.Name)"
						SubscriptionId  = "$($azSub.Id)"
						ConsumedService = "$svcName"
						Instances       = "$svcQty"
						StartDate       = "$StartDate"
						EndDate         = "$EndDate"
						SumTotal        = "$cost"
					}
				}
			} else {
				Write-Host "`tNo resources or consumptions costs were returned for the time period" -ForegroundColor Magenta
			}
			$counter++
		}
	} catch {
		$msg = $_.Exception.Message
		[pscustomobject]@{
			Status   = 'Error'
			Activity = $($_.CategoryInfo.Activity -join(";"))
			Message  = $($_.Exception.Message -join(";"))
			Trace    = $($_.ScriptStackTrace -join(";"))
			RunOn    = $env:COMPUTERNAME
			RunAs    = $env:USERNAME
		}
	} finally {
		if ($curContext -and ($curContext.Subscription.Id -ne $azSub.Id)) {
			Write-Host "Restoring Azure session context" -ForegroundColor Cyan
			$null = Set-AzContext $curContext
		}
	}
}