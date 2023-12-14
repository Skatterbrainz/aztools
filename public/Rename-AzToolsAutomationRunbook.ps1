function Rename-AzToolsAutomationRunbook {
	<#
	.SYNOPSIS
		Rename an Azure Automation Runbook
	.DESCRIPTION
		Rename an Azure Automation Runbook by downloading the source, creating a new runbook with
		the new name and deleting the old runbook.
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER Name
		Optional. Name of runbook to rename. If left blank, will display runbooks in a Gridview to select from.
	.PARAMETER NewName
		Required. New name for the runbook.
		A runbook with the same name must not exist in the same Automation Account.
	.PARAMETER Description
		Optional. Description to assign to the new runbook. If blank, will be copied from the source runbook.
	.PARAMETER CopyTags
		Optional. Tags to assign to new runbook. If blank, will be copied from the source runbook.
	.PARAMETER KeepOriginal
		Optional. Copies source to new runbook without deleting the original. Default behavior is to delete the 
		original runbook after the copy is created.
	.EXAMPLE
		Rename-AzToolsAutomationRunbook -NewName "Get-ADStaleDevices"

		Prompts for selection of source/original runbook, and renames it to Get-ADStaleDevices
	.EXAMPLE
		Rename-AzToolsAutomationRunbook -Name "Get-StaleDevices" -NewName "Get-ADStaleDevices"

		Renames Get-StaleDevices to Get-ADStaleDevices
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Rename-AzToolsAutomationRunbook.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext,
		[parameter(Mandatory=$False,HelpMessage="Original or Source Name of Runbook to be renamed")]
			[string]$Source,
		[parameter(Mandatory=$False,HelpMessage="New Name to apply to Runbook")]
			[string]$NewName,
		[parameter(Mandatory=$False,HelpMessage="New Description for Runbook. Default is to use the existing Description")]
			[string]$Description,
		[parameter(Mandatory=$False,HelpMessage="Copy Azure Resource Tags to new Runbook")]
			[switch]$CopyTags,
		[parameter(Mandatory=$False,HelpMessage="Keep original Runbook, or Copy instead of Rename")]
			[switch]$KeepOriginal
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
				$runbooks = Get-AzAutomationRunbook @params | Sort-Object Name #| Select-Object Name,RunbookType,Location,State,LastModifiedTime
				if (![string]::IsNullOrWhiteSpace($Source)) {
					Write-Verbose "Filtering results on: $Filter"
					$runbook1 = $runbooks | Where-Object { $_.Name -eq $Source }
				} else {
					$rb = $runbooks | Select-Object Name,ResourceGroupName,AutomationAccountName |
						Out-GridView -Title "Select Source Runbook" -OutputMode Single
					if ($rb) {
						$runbook1 = $runbooks | Where-Object {$_.Name -eq $rb.Name}
					}
				}
				if ($runbook1) {
					if ($NewName -in ($runbooks | Select-Object -ExpandProperty Name)) {
						Write-Warning "Destination runbook exists: $NewName"
					} else {
						$tempfilepath = (Join-Path $env:TEMP $runbook1.Name)
						if ($runbook1.State -eq "Edit") {
							$slotName = "Draft"
						} else {
							$slotName = "Published"
						}
						$params = @{
							Name                  = $runbook1.Name
							OutputFolder          = "$($env:temp)"
							ResourceGroupName     = $runbook1.ResourceGroupName
							AutomationAccountName = $runbook1.AutomationAccountName
							Slot                  = $slotName
							Force                 = $True
						}
						$rbfile   = Export-AzAutomationRunbook @params
						$filepath = (Join-Path $env:TEMP $rbfile.Name)
						if (Test-Path $filepath) {
							Write-Verbose "Uploading from: $filepath"
							$params = @{
								Path                  = $filepath
								Name                  = $NewName
								ResourceGroupName     = $runbook1.ResourceGroupName
								AutomationAccountName = $runbook1.AutomationAccountName
								Type                  = $runbook1.RunbookType
							}
							if ($CopyTags) {
								$params['Tags'] = $runbook1.Tags
							}
							if (![string]::IsNullOrWhiteSpace($Description)) {
								$params['Description'] = $Description
							} else {
								$params['Description'] = $runbook1.Description
							}
							$result = Import-AzAutomationRunbook @params
							if ($result) {
								if (-not $KeepOriginal) {
									Write-Verbose "Removing source: $($runbook1.Name)"
									$params = @{
										Name = $runbook1.Name
										ResourceGroupName = $runbook1.ResourceGroupName
										AutomationAccountName = $runbook1.AutomationAccountName
										Force = $True
									}
									Remove-AzAutomationRunbook @params
								} else {
									Write-Verbose "Source runbook not deleted: $($runbook1.Name)"
								}
							}
							$result
						} else {
							Write-Warning "Error downloading temp file: $tempfilepath"
						}
					}
				} else {
					Write-Verbose "Nothing was selected. I'm going back to sleep."
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