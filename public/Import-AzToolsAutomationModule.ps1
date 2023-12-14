function Import-AzToolsAutomationModule {
	<#
	.SYNOPSIS
		Import a PowerShell module into an Azure Automation Account
	.DESCRIPTION
		Import or Update a PowerShell module into an Azure Automation Account
	.PARAMETER ModuleName
		Name of module in PowerShell Gallery
	.PARAMETER ModuleVersion
		Optional. Version to be imported. If not provided, the latest/current version is imported
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Import-AzAutomationToolsModule -ModuleName az.accounts

		Imports current/latest version from the PowerShell Gallery
	.EXAMPLE
		Import-AzToolsAutomationModule -ModuleName az.accounts -ModuleVersion 2.12.1

		Imports version 2.12.1 from the PowerShell Gallery
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsAutomationModule.md
	#>
	[CmdletBinding()]
	[OutputType([Microsoft.Azure.Commands.Automation.Model.Module])]
	param (
		[parameter(Mandatory=$True,HelpMessage="Name of PowerShell Module")]
			[ValidateNotNullOrEmpty()][string]$ModuleName,
		[parameter(Mandatory=$False,HelpMessage="Module Version to update to, or blank for latest")]
			[string]$ModuleVersion,
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AzToolsLastSubscription -or $SelectContext) { Select-AzToolsSubscription }
	if ($global:AzToolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
			if ($global:AzToolsLastAutomationAccount) {
				$(Get-AzContext)
				try {
					if ($ModuleVersion) {
						$Module = Find-Module -Name $ModuleName -RequiredVersion $ModuleVersion -ErrorAction Stop
					} else {
						$Module = Find-Module -Name $ModuleName -ErrorAction Stop
					}
				} catch {
					Write-Warning "Module [$ModuleName] version [$ModuleVersion] was not found in PSGallery"
				}
				if ($Module) {
					$ModuleContentUrl = "{0}/package/{1}/{2}" -f $Module.RepositorySourceLocation, $Module.Name, $Module.Version
					# Find the actual blob storage location of the module
					do {
						try {
							[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
							$null = Invoke-WebRequest -Uri $ModuleContentUrl -MaximumRedirection 0 -UseBasicParsing -ErrorAction Stop
						} catch {
							$ModuleContentUrl = $_.Exception.Response.Headers.Location.AbsoluteUri
						}
						if ([string]::IsNullOrEmpty($ModuleContentUrl)) {
							Write-Error "Unable to find upload URL for '$($Module.Name)'"
							break
						}
					} while (-not $ModuleContentUrl.Contains(".nupkg"))

					Write-Host  -ForegroundColor Green "$($Module.Name) : Importing module version $($Module.Version) to Automation Account (please wait)..."

					$upload = New-AzAutomationModule @AutomationAccount -Name $Module.Name -ContentLink $ModuleContentUrl

					while("Failed","Succeeded" -notcontains $upload.ProvisioningState){
						Start-Sleep -Seconds 1
						$upload = Get-AzAutomationModule @AutomationAccount -Name $Module.Name
						Write-Verbose "$($upload.Name) : $($upload.ProvisioningState)"
					}

					if ($upload.ProvisioningState -eq "Failed"){
						Write-Error "Error uploading the module '$($upload.Name)'"
					} else {
						Write-Host "Import completed successfully!" -ForegroundColor Green
					}

					$upload
				}
			}
		}
	} else {
		Write-Warning "Azure Subscription not yet selected"
	}
}