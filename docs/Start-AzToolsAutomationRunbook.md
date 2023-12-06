---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Start-AzToolsAutomationRunbook.md
schema: 2.0.0
---

# Start-AzToolsAutomationRunbook

## SYNOPSIS
Start an Azure Automation Runbook

## SYNTAX

```
Start-AzToolsAutomationRunbook [-SelectContext] [[-Name] <String>] [[-RunOn] <String>] [-NoWait]
 [[-MaxWaitSeconds] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Start an Azure Automation Runbook and get the return value

## EXAMPLES

### EXAMPLE 1
```
Start-AzToolsAutomationRunbook
```

Prompts for selecting Runbook, and input parameters (if any are found)

### EXAMPLE 2
```
Start-AzToolsAutomationRunbook -Name "MyRunBook"
```

Runs MyRunBook.
Prompts for input parameters (if any are found)

### EXAMPLE 3
```
Start-AzToolsAutomationRunbook -Name "MyRunBook" -RunOn HybridWorkerGroup
```

Runs MyRunBook.
Prompts for input parameters (if any are found) and prompts for Hybrid worker group.

### EXAMPLE 4
```
Start-AzToolsAutomationRunbook -SelectContext
```

Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
prompts for Runbook, and input parameters (if any are found)

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

### -Name
Optional.
Name of Runbook.
If not provided, a GridView will be displayed for selection.

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

### -RunOn
Optional.
Azure or HybridWorkerGroup.
Default is Azure
If HybridWorkerGroup is selected, a GridView will be displayed for selecting the HybridWorkerGroup name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Azure
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWait
Optional.
Do not wait for completion.

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

### -MaxWaitSeconds
Optional.
If \[NoWait\] is not referenced, this limits the wait time to the specified number of seconds.
Default is 180 seconds (3 minutes)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 180
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
Output includes explicit return values from runbook, as well as: HasErrors,RowError,RowState,Table
so you will likely want to filter the output to only the explicit return properties.

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Start-AzToolsAutomationRunbook.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Start-AzToolsAutomationRunbook.md)

