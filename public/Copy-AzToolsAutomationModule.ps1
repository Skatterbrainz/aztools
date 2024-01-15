<#
.SYNOPSIS
	Copy PowerShell modules from one Automation Account to another
.DESCRIPTION
	Copy PowerShell modules from one Automation Account to another
	Copy modules between subscriptions (eventually, I'm still working on that)
.PARAMETER SelectContext
	Optional. Prompt to select the Azure context (tenant/subscription)
.EXAMPLE
.NOTES
.LINK
	https://github.com/Skatterbrainz/aztools/tree/main/docs/Copy-AzToolsAutomationModule.md
#>
function Copy-AzToolsAutomationModule {
	[CmdletBinding()]
	param(
		[parameter()][switch]$SelectContext
	)
	#if ($SelectContext) { Switch-AzToolsContext }
	$modules = Get-AzToolsAutomationModule -SelectContext:$SelectContext | Where-Object {$_.IsGlobal -ne $True}
	if ($modules.Count -gt 0) {
		if (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable) {
			$copyList = $modules | Out-ConsoleGridView -Title "Select Source Modules" -OutputMode Multiple
		} else {
			$copyList = $modules | Out-GridView -Title "Select Source Modules" -OutputMode Multiple
		}
		if ($copyList.Count -gt 0) {
			$sourceList = @()
			foreach ($module in $copyList) {
				Write-Host "Checking PSGallery for $($module.Name) $($module.Version)..." -ForegroundColor Cyan
				$found = $null
				try {
					$found = Find-Module -Name $($module.Name) -RequiredVersion $($module.Version) -ErrorAction Stop
					if ($found.Dependencies) {
						$deps = [pscustomobject]$($found.Dependencies)
						Write-Warning "$($module.Name) has dependencies"
						$sourceList += $deps | Select-Object Name,@{l='Version';e={$_.MinimumVersion}},@{l='Source';e={'PSGallery'}},@{l='Dependencies';e={$False}}
					}
					$sourceList += $module | Select-Object Name,Version,@{l='Source';e={'PSGallery'}},@{l='Dependencies';e={$True}}
				} catch {
					#Write-Host "$($module.Name) $($module.Version) was not found in PSGallery" -ForegroundColor Cyan
					$sourceList += $module | Select-Object Name,Version,@{l='Source';e={'Custom'}},@{l='Dependencies';e={$False}}
				}
			}
			$sourceList
		}
	}
}