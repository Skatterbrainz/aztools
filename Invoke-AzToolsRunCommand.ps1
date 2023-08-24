function Invoke-AzToolsRunCommand  {
	[CmdletBinding()]
	param (
		[parameter()][string]$ScriptContent,
		[parameter()][string]$ScriptFile,
		[parameter()][switch]$SelectContext,
		[parameter()][switch]$SelectSubscription,
		[parameter()][string]$RunCommandName = "AzToolsRunCommand",
		[parameter()][int32]$WaitSeconds = 10,
		[parameter()][int32]$TryCount = 10
	)
	# $tryCount * $waitSeconds = totalTime to wait if job doesn't finish
	if ($SelectContext) { Switch-AzToolsContext }
	if ([string]::IsNullOrWhiteSpace($VMName)) {
		[array]$vms = Get-AzToolsMachines -SelectSubscription:$SelectSubscription
		$vms = $vms | Select-Object Name,ResourceGroupName,PowerState,OsName,Location,SubscriptionId,Id |
			Sort-Object Name | Out-GridView -Title "Select Machines to Send Command to" -OutputMode Multiple
		$vmcount = $vms.Count
		$vmnum   = 1
	}
	if ($vmcount -eq 0) { break }
	if (![string]::IsNullOrEmpty($ScriptContent)) {
		$encodedcommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($ScriptContent))
	} elseif (![string]::IsNullOrEmpty($ScriptFile)) {
		if (Test-Path -Path $ScriptFile) {
			$ScriptContent = Get-Content -Path $ScriptFile -Raw
			$encodedcommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($ScriptContent))
		} else {
			throw "File not found: $ScriptFile"
		}
	} else {
		throw "Either -ScriptContent or -FilePath must be provided"
	}
	$PSSource = "$($prefix)powershell.exe -EncodedCommand  $EncodedCommand"
	foreach ($vm in $vms) {
		Write-Host "Machine $vmnum of $vmcount - $($vm.Name)" -ForegroundColor Cyan
		try {
			if ($vm.StorageProfile.OsDisk.OsType -eq 'Windows') {
				$prefix = '. '
			} else {
				$prefix = ''
			}
			$AzVMRunCommand = @{
				ResourceGroupName = $VM.ResourceGroupName
				VMName            = $VM.Name
				RunCommandName    = $RunCommandName
				SourceScript      = $PSSource
				Location          = $VM.Location
				AsJob             = $true
				ErrorAction       = 'Stop'
			}
			Write-Host "Submitting runcommand to machine: $Name" -ForegroundColor Cyan
			$SetCmd = Set-AzVMRunCommand @AzVMRunCommand
			[pscustomobject]@{
				ResourceId        = $VM.Id
				ResourceGroupName = $VM.ResourceGroupName
				Name              = $VM.Name
				CommandName       = $RunCommandName
				State             = $SetCmd.State
				Type              = 'VM'
			}
			Write-Host ""
			$jobstate = $($setcmd.JobStateInfo).State
			$counter = 0
			while (($counter -lt $tryCount) -and ($jobstate -eq 'Running')) {
				Write-Host "JobState: $jobstate - (pause 10 seconds)..."
				Start-Sleep -Seconds $waitSeconds
				$jobstate = $($setcmd.JobStateInfo).State
				$counter++
			}
			Write-Host "JobState: $jobstate"
			if ($jobstate -eq 'Completed') {
				Write-Host "Getting job output..."
				$rest = Invoke-AzRestMethod -Path "$($VM.Id)/runCommands/$($RunCommandName)?`$expand=instanceView&api-version=2022-11-01" -Method GET
				if ($rest.StatusCode -eq 200) {
					if (($rest.Content | ConvertFrom-Json).Properties.provisioningState -eq 'Succeeded') {
						Write-Host "Returning output..." -ForegroundColor Cyan
						$iview = Get-AzVMRunCommand -ResourceGroupName $vm.ResourceGroupName -VMName $vm.name -RunCommandName $runcommandname -Expand InstanceView
						$iview.InstanceView.Output
					}
				} else {
					$msg = "StatusCode: $($rest.StatusCode)"
					if ($rest.StatusCode -eq 404) {
						$msg += " - verify you have access (Contributor/Owner) and check if your PIM session is still active"
					}
					throw $msg
				}
			}
		} catch {
			[pscustomobject]@{
				Status   = 'Error'
				Activity = $($_.CategoryInfo.Activity -join (";"))
				Message  = $($_.Exception.Message -join (";"))
				Trace    = $($_.ScriptStackTrace -join (";"))
				RunAs    = $($env:USERNAME)
				RunOn    = $($env:COMPUTERNAME)
			}
		}
		$vmnum++
	}
}