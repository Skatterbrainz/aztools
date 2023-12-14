function Invoke-AzToolsVmRunCommand  {
	<#
	.SYNOPSIS
		Invoke the "Run Command" feature on an Azure Virtual Machine using PowerShell
	.DESCRIPTION
		Invoke the Azure VM "Run Command" to submit PowerShell code to remote machines and
		return the result. Script code can be provided in-line or from a script file.
	.PARAMETER ScriptContent
		Optional. PowerShell statement to run on the remote machine.
		Example: Get-Process | Sort-Object WorkingSet -Desc | Select-Object -First 3
		Note: Either -ScriptContent or -ScriptFile must be provided, not both
	.PARAMETER ScriptFile
		Optional. File containing PowerShell script code to run on the remote machine.
		Note: Either -ScriptContent or -ScriptFile must be provided, not both
	.PARAMETER SelectContext
		Optional. Prompt to select the Azure context (tenant/subscription)
	.PARAMETER SelectSubscription
		Optional. Prompt to select Subscriptions to query machines.
		Default is to query the current subscription context only.
	.PARAMETER RunCommandName
		Optional. Name of RunCommand. Default is "AzToolsRunCommand"
	.PARAMETER WaitSeconds
		Optional. Number of seconds to wait for job completion on each VM between polling cycles
		Default is 10 (seconds)
	.PARAMETER TryCount
		Optional. Number of times to poll for job completion
		Default is 10 (retries)
	.EXAMPLE
		Invoke-AzToolsVmRunCommand -ScriptContent "Get-Service BITS"
		Prompts user to select VM's to run the command on from within the current subscription context.
	.EXAMPLE
		Invoke-AzToolsVmRunCommand -ScriptContent "Get-Service BITS" -SelectSubscription
		Prompts user to select the Subscriptions to query VM's and then prompts to select the VM's to run the command on.
	.LINK
		https://github.com/Skatterbrainz/aztools/tree/main/docs/Invoke-AzToolsVmRunCommand.md
	#>
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$False,HelpMessage="Script Content to execute on remote machine")]
			[string]$ScriptContent,
		[parameter(Mandatory=$False,HelpMessage="Script file to import an excute on remote machine")]
			[string]$ScriptFile,
		[parameter(Mandatory=$False,HelpMessage="Select Azure Context")]
			[switch]$SelectContext,
		[parameter(Mandatory=$False,HelpMessage="Select Subscription to query for remote machines")]
			[switch]$SelectSubscription,
		[parameter(Mandatory=$False,HelpMessage="Name of Run Command. Default is AzToolsRunCommand")]
			[string]$RunCommandName = "AzToolsRunCommand",
		[parameter(Mandatory=$False,HelpMessage="Number of seconds to pause per wait cycle")]
			[int32]$WaitSeconds = 10,
		[parameter(Mandatory=$False,HelpMessage="Number of wait cycles to return result. Total time is (TryCount * WaitSeconds)")]
			[int32]$TryCount = 10
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