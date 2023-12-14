function Get-AzToolsAutomationAccount {
	<#
	.SYNOPSIS
		Display summary information for Azure Automation Account
	.DESCRIPTION
		Returns summary information about an Azure Automation Account, including
		Automation Account name, Resource Group, Location, Plan, Tags, and counts of
		assets such as Runbooks, Variables and Credentials. If -Detailed is used, the
		primary key, secondary key and endpoint information is returned also.
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Detailed
		Optional. Includes information for the Primary Key, Secondary Key and Endpoint URI
	.EXAMPLE
		Get-AzToolsAutomationAccount
	.EXAMPLE
		Get-AzToolsAutomationAccount -Detailed
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationAccount.md
	#>
	[CmdletBinding()]
	param(
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext,
		[parameter(Mandatory=$False,HelpMessage="Show Detailed results")]
			[switch]$Detailed
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
				$params1 = @{
					ResourceGroupName = $AzToolsLastResourceGroup.ResourceGroupName
					AutomationAccountName = $AzToolsLastAutomationAccount.AutomationAccountName
				}
				Write-Verbose "Account=$((Get-AzContext).Account) Subscription=$($AzToolsLastSubscription.Id) ResourceGroup=$($global:AzToolsLastResourceGroup.ResourceGroupName) AutomationAccount=$($script:AzToolsLastAutomationAccount.AutomationAccountName)"
				Write-Host "Getting Automation Account properties" -ForegroundColor Cyan
				$aaX = Get-AzAutomationAccount -ResourceGroupName $AzToolsLastResourceGroup.ResourceGroupName -Name $AzToolsLastAutomationAccount.AutomationAccountName
				Write-Verbose "Getting automation account registration info"
				$aaReg = Get-AzAutomationRegistrationInfo @params1
				Write-Verbose "Getting runbooks"
				$aaRbs = Get-AzAutomationRunbook @params1
				Write-Verbose "Getting modules"
				$aaMod = Get-AzAutomationModule @params1
				Write-Verbose "Getting schedules"
				$aaSch = Get-AzAutomationSchedule @params1
				Write-Verbose "Getting variables"
				$aaVar = Get-AzAutomationVariable @params1
				Write-Verbose "Getting credentials"
				$aaCrd = Get-AzAutomationCredential @params1
				Write-Verbose "Getting certificates"
				$aaCer = Get-AzAutomationCertificate @params1
				Write-Verbose "Getting webhooks"
				$aaWeb = Get-AzAutomationWebhook @params1
				Write-Verbose "Getting connections"
				$aaCon = Get-AzAutomationConnection @params1
				Write-Verbose "Getting hybrid worker groups"
				$hwU = Get-AzAutomationHybridRunbookWorkerGroup @params1
				$hwS = Get-AzAutomationHybridWorkerGroup @params1 | Where-Object {$_.GroupType -ne "User"}
				[pscustomobject]@{
					AccountName   = $AzToolsLastAutomationAccount.AutomationAccountName
					ResourceGroup = $aaX.ResourceGroupName
					Subscription  = $aaX.SubscriptionId
					Location      = $aaX.Location
					Plan          = $aaX.Plan
					State         = $aaX.State
					CreatedOn     = $aaX.CreationTime
					ModifiedOn    = $aaX.LastModifiedTime
					Tags          = $aaX.Tags
					PrimaryKey    = if ($Detailed) { $aaReg.PrimaryKey } else { '********' }
					SecondaryKey  = if ($Detailed) { $aaReg.SecondaryKey } else { '********' }
					Endpoint      = if ($Detailed) { $aaReg.Endpoint } else { '********' }
					Runbooks      = $aaRbs.Count
					Modules       = $aaMod.Count
					Schedules     = $aaSch.Count
					Variables     = $aaVar.Count
					Credentials   = $aaCrd.Count
					Certificates  = $aaCer.Count
					WebHooks      = $aaWeb.Count
					Connections   = $aaCon.Count
					HWG_User      = $hwU.Count
					HWG_System    = $hwS.Count
				}
			}
		}
	}
}