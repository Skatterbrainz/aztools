---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbookSchedules.md
schema: 2.0.0
---

# Get-AzToolsAutomationRunbookSchedules

## SYNOPSIS
Get Azure Automation Runbooks with an assigned Schedule

## SYNTAX

```
Get-AzToolsAutomationRunbookSchedules [-SelectContext] [<CommonParameters>]
```

## DESCRIPTION
Get and/or export Azure Automation Runbooks with an assigned Schedule

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationRunbookSchedules
```

Returns all runbooks in the active Automation Account with an assigned Schedule

### EXAMPLE 2
```
Get-AzToolsAutomationRunbookSchedules -SelectContext
```

Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
returns all runbooks in the selected Automation Account with an assigned ScheduleName

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbookSchedules.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbookSchedules.md)

