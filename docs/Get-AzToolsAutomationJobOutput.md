---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobOutput.md
schema: 2.0.0
---

# Get-AzToolsAutomationJobOutput

## SYNOPSIS
Get Azure Automation runbook job output

## SYNTAX

```
Get-AzToolsAutomationJobOutput [-JobId] <String> [-SelectContext] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get Azure Automation runbook job output

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationJobOutput -JobID abcdbf6d-1234-abcd-efgh-a5633676041c
```

## PARAMETERS

### -JobId
Required.
Automation Job ID

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobOutput.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobOutput.md)

