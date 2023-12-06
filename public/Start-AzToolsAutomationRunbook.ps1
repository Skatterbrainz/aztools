function Start-AzToolsAutomationRunbook {
	<#
	.SYNOPSIS
		Start an Azure Automation Runbook
	.DESCRIPTION
		Start an Azure Automation Runbook and get the return value
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Name
		Optional. Name of Runbook. If not provided, a GridView will be displayed for selection.
	.PARAMETER RunOn
		Optional. Azure or HybridWorkerGroup. Default is Azure
		If HybridWorkerGroup is selected, a GridView will be displayed for selecting the HybridWorkerGroup name.
	.PARAMETER NoWait
		Optional. Do not wait for completion.
	.PARAMETER MaxWaitSeconds
		Optional. If [NoWait] is not referenced, this limits the wait time to the specified number of seconds.
		Default is 180 seconds (3 minutes)
	.PARAMETER DailyQuote
		Optional. Show daily random ZenQuote (see Notes)
	.EXAMPLE
		Start-AzToolsAutomationRunbook

		Prompts for selecting Runbook, and input parameters (if any are found)
	.EXAMPLE
		Start-AzToolsAutomationRunbook -Name "MyRunBook"

		Runs MyRunBook. Prompts for input parameters (if any are found)
	.EXAMPLE
		Start-AzToolsAutomationRunbook -Name "MyRunBook" -RunOn HybridWorkerGroup

		Runs MyRunBook. Prompts for input parameters (if any are found) and prompts for Hybrid worker group.
	.EXAMPLE
		Start-AzToolsAutomationRunbook -SelectContext

		Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
		prompts for Runbook, and input parameters (if any are found)
	.NOTES
		Output includes explicit return values from runbook, as well as: HasErrors,RowError,RowState,Table
		so you will likely want to filter the output to only the explicit return properties.
		Uses ZenQuotes API / reference: https://docs.zenquotes.io/zenquotes-documentation/

		ZenQuotes usage limits: Requests are restricted by IP to 5 per 30 second period by default.
		An API key or registered IP is required for unlimited access and to enable Access-Control-Allow-Origin headers.
		We require that you show attribution with a link back to https://zenquotes.io/ when using the free version of this API.
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Start-AzToolsAutomationRunbook.md
	#>
	[CmdletBinding()]
	param (
		[parameter()][switch]$SelectContext,
		[parameter()][string]$Name,
		[parameter()][string][ValidateSet('Azure','HybridWorkerGroup')]$RunOn = 'Azure',
		[parameter()][switch]$NoWait,
		[parameter()][int32]$MaxWaitSeconds = 180,
		[parameter()][switch]$DailyQuote
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		Write-Verbose "Subscription: $($AzToolsLastSubscription.Id) - $($AzToolsLastSubscription.Name)"
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			Write-Verbose "Resource group: $AzToolsLastResourceGroup"
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$aaname = $global:AzToolsLastAutomationAccount.AutomationAccountName
				$rgname = $global:AzToolsLastResourceGroup.ResourceGroupName
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($rgname) AutomationAccount=$($aaname)"
				$params = @{
					ResourceGroupName = $rgname
					AutomationAccountName = $aaname
				}
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name
				if (![string]::IsNullOrWhiteSpace($Name)) {
					$runbook = $runbooks | Where-Object {$_.Name -eq $Name} | Select-Object -ExpandProperty Name
				} else {
					Write-Host "Waiting for GridView selection: Runbook" -ForegroundColor Cyan
					$rbook = $runbooks | Select-Object Name | Out-GridView -Title "Select Runbook to Execute" -OutputMode Single
					if ($rbook) { $runbook = $rbook.Name } else { $runbook = $null }
				}
				Write-Verbose "Selected Runbook: $($runbook)"
				if ($runbook) {
					$params = @{
						Name                  = $runbook
						ResourceGroupName     = $AzToolsLastResourceGroup.ResourceGroupName
						AutomationAccountName = $global:AzToolsLastAutomationAccount.AutomationAccountName
					}
					Write-Verbose "Getting runbook properties: $($runbook)"
					$azRunbook = Get-AzAutomationRunbook @params
					Write-Verbose "Getting runbook parameters: $($runbook)"
					$rbParams = $azRunbook | Select-Object -ExpandProperty Parameters | Select-Object -ExpandProperty Keys
					$rbParamSet = @{}
					foreach ($rbParam in $rbParams) {
						$pval = $null
						$pval = Read-Host -Prompt "Value for parameter [$rbParam]"
						if (![string]::IsNullOrEmpty($pval)) {
							if ($pval -eq "True") {
								$rbParamSet["$rbParam"] = $True
							} elseif ($pval -eq "False") {
								$rbParamSet["$rbParam"] = $False
							} else {
								$rbParamSet["$rbParam"] = $pval
							}
						}
					}
					if ($RunOn -ne 'Azure') {
						$params = @{
							ResourceGroupName     = $AzToolsLastResourceGroup.ResourceGroupName
							AutomationAccountName = $AzToolsLastAutomationAccount.AutomationAccountName
						}
						Write-Verbose "Getting Hybrid Runbook Worker Groups..."
						$hwgroups = Get-AzAutomationHybridRunbookWorkerGroup @params
						$hwg = $hwgroups | Select-Object -ExpandProperty Name
						Write-Host "Waiting for GridView selection: Hybrid Worker Group" -ForegroundColor Cyan
						$hwgroup = $hwg | Out-GridView -Title "Select Hybrid Runbook Worker Group" -OutputMode Single
					}
					$params = @{
						Name                  = $runbook
						ResourceGroupName     = $AzToolsLastResourceGroup.ResourceGroupName
						AutomationAccountName = $AzToolsLastAutomationAccount.AutomationAccountName
						ErrorAction           = 'Stop'
					}
					if (!$NoWait) {
						$params['Wait'] = $True
						$params['MaxWaitSeconds'] = $MaxWaitSeconds
					}
					if ($hwgroup) {
						$params['RunOn'] = $hwgroup
					}
					if ($rbParamSet.Count -gt 0) {
						Write-Verbose "Appending runbook parameter set..."
						$params['Parameters'] = $rbParamSet
					} else {
						Write-Verbose "No input parameters being included"
					}
					if ($DailyQuote) {
						$zquote = Invoke-RestMethod -Uri "https://zenquotes.io/api/quotes" -UseBasicParsing -Method Get
						#$zquote = (Invoke-WebRequest -UseBasicParsing -Uri "https://zenquotes.io/api/quotes").Content | ConvertFrom-Json
						$zcount = $zquote.Count
						$zitem = Get-Random -Maximum $zcount
						Write-Host "Daily quote: `"$($zquote[$zitem].q)`" - $($zquote[$zitem].a)" -ForegroundColor Magenta
						Write-Host "Source = ZenQuotes: https://zenquotes.io/" -ForegroundColor Magenta
					}
					Write-Host "Submitting Runbook start request: $($runbook)" -ForegroundColor Cyan
					if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
						Write-Verbose "Runbook parameter set..."
						$params
					}
					Start-AzAutomationRunbook @params
				}
			} else {
				Write-Warning "Automation Account not yet selected"
			}
		} else {
			Write-Warning "Resource Group not yet selected"
		}
	} else {
		Write-Warning "Azure Subscription not yet selected"
	}
}