---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Invoke-AzToolsVmRunCommand.md
schema: 2.0.0
---

# Invoke-AzToolsVmRunCommand

## SYNOPSIS
Invoke the "Run Command" feature on an Azure Virtual Machine using PowerShell

## SYNTAX

```
Invoke-AzToolsVmRunCommand [[-ScriptContent] <String>] [[-ScriptFile] <String>] [-SelectContext]
 [-SelectSubscription] [[-RunCommandName] <String>] [[-WaitSeconds] <Int32>] [[-TryCount] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Invoke the Azure VM "Run Command" to submit PowerShell code to remote machines and
return the result.
Script code can be provided in-line or from a script file.

## EXAMPLES

### EXAMPLE 1
```
Invoke-AzToolsVmRunCommand -ScriptContent "Get-Service BITS"
Prompts user to select VM's to run the command on from within the current subscription context.
```

### EXAMPLE 2
```
Invoke-AzToolsVmRunCommand -ScriptContent "Get-Service BITS" -SelectSubscription
Prompts user to select the Subscriptions to query VM's and then prompts to select the VM's to run the command on.
```

## PARAMETERS

### -ScriptContent
Optional.
PowerShell statement to run on the remote machine.
Example: Get-Process | Sort-Object WorkingSet -Desc | Select-Object -First 3
Note: Either -ScriptContent or -ScriptFile must be provided, not both

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptFile
Optional.
File containing PowerShell script code to run on the remote machine.
Note: Either -ScriptContent or -ScriptFile must be provided, not both

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelectContext
Optional.
Prompt to select the Azure context (tenant/subscription)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelectSubscription
Optional.
Prompt to select Subscriptions to query machines.
Default is to query the current subscription context only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunCommandName
Optional.
Name of RunCommand.
Default is "AzToolsRunCommand"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: AzToolsRunCommand
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitSeconds
Optional.
Number of seconds to wait for job completion on each VM between polling cycles
Default is 10 (seconds)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -TryCount
Optional.
Number of times to poll for job completion
Default is 10 (retries)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Invoke-AzToolsVmRunCommand.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Invoke-AzToolsVmRunCommand.md)

