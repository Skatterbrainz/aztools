---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Rename-AzToolsAutomationRunbook.md
schema: 2.0.0
---

# Rename-AzToolsAutomationRunbook

## SYNOPSIS
Rename an Azure Automation Runbook

## SYNTAX

```
Rename-AzToolsAutomationRunbook [-SelectContext] [[-Source] <String>] [[-NewName] <String>]
 [[-Description] <String>] [-CopyTags] [-KeepOriginal] [<CommonParameters>]
```

## DESCRIPTION
Rename an Azure Automation Runbook by downloading the source, creating a new runbook with
the new name and deleting the old runbook.

## EXAMPLES

### EXAMPLE 1
```
Rename-AzToolsAutomationRunbook -NewName "Get-ADStaleDevices"
```

Prompts for selection of source/original runbook, and renames it to Get-ADStaleDevices

### EXAMPLE 2
```
Rename-AzToolsAutomationRunbook -Name "Get-StaleDevices" -NewName "Get-ADStaleDevices"
```

Renames Get-StaleDevices to Get-ADStaleDevices

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

### -Source
Original or Source Name of Runbook to be renamed

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

### -NewName
Required.
New name for the runbook.
A runbook with the same name must not exist in the same Automation Account.

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

### -Description
Optional.
Description to assign to the new runbook.
If blank, will be copied from the source runbook.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CopyTags
Optional.
Tags to assign to new runbook.
If blank, will be copied from the source runbook.

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

### -KeepOriginal
Optional.
Copies source to new runbook without deleting the original.
Default behavior is to delete the 
original runbook after the copy is created.

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Rename-AzToolsAutomationRunbook.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Rename-AzToolsAutomationRunbook.md)

