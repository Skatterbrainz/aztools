---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationLastJob.md
schema: 2.0.0
---

# Get-AzToolsAutomationLastJob

## SYNOPSIS
Get date and time of most recent Runbook job execution

## SYNTAX

```
Get-AzToolsAutomationLastJob [-RunbookName] <String> [-SelectContext] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get the date and time of the most recent Azure Automation Runbook job execution

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationLastJob -RunbookName "Get-MachinesByTag"
```

## PARAMETERS

### -RunbookName
Name of runbook to query last job execution

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationLastJob.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationLastJob.md)

