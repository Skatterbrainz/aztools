function Import-AzToolsModule {
	<#
	.DESCRIPTION
		Import/Update module into Azure Automation Account
	.PARAMETER ModuleName
		Name of module in PS Gallery
	.PARAMETER ModuleVersion
		Version to be imported
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.EXAMPLE
		Import-AzToolsModules -ModuleName az.accounts -ModuleVersion 2.12.1
	#>
	[CmdletBinding()]
	[OutputType([Microsoft.Azure.Commands.Automation.Model.Module])]
	param (
		[parameter(Mandatory)][string]$ModuleName,
		[parameter()][string]$ModuleVersion,
		[parameter()][switch]$SelectContext
	)
	if ($SelectContext) { Switch-AzToolsContext }
	if (!$global:AztoolsLastSubscription -or $SelectContext) {
		$azsubs = Get-AzSubscription
		if ($azsub = $azsubs | Out-GridView -Title "Select Subscription" -OutputMode Single) {
			$global:AztoolsLastSubscription = $azsub
		}
	}
	if ($global:AztoolsLastSubscription) {
		if (!$global:AzToolsLastResourceGroup -or $SelectContext) { Select-AzToolsResourceGroup }
		if ($global:AzToolsLastResourceGroup) {
			if (!$global:AzToolsLastAutomationAccount -or $SelectContext) { Select-AzToolsAutomationAccount }
		}
	}
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
					Invoke-WebRequest -Uri $ModuleContentUrl -MaximumRedirection 0 -UseBasicParsing -ErrorAction Stop | Out-Null
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
	} else {
		Write-Host "Run Switch-AzToolsContext first" -ForegroundColor Yellow
	}
}