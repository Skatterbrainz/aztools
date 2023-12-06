---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationHybridWorker.md
schema: 2.0.0
---

# Get-AzToolsAutomationHybridWorker

## SYNOPSIS
Get Automation Account Hybrid Worker status

## SYNTAX

```
Get-AzToolsAutomationHybridWorker [-SelectContext] [[-ThresholdMinutes] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get Azure Automation Account Hybrid Workers and their current status.
Only returns User hybrid workers (not system)

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationHybridWorker
```

### EXAMPLE 2
```
Get-AzToolsAutomationHybridWorker -SelectContext
```

### EXAMPLE 3
```
Get-AzToolsAutomationHybridWorker -ThresholdMinutes 45
```

## PARAMETERS

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

### -ThresholdMinutes
Optional.
Number of minutes to allow for last-seen time before considering it a concern.
Default is 30 minutes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationHybridWorker.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationHybridWorker.md)

