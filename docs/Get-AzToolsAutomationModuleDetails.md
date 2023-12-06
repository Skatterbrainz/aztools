---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationModuleDetails.md
schema: 2.0.0
---

# Get-AzToolsAutomationModuleDetails

## SYNOPSIS
Get the module details from the PowerShell Gallery and returns any dependencies

## SYNTAX

```
Get-AzToolsAutomationModuleDetails [-ModuleName] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationModuleDetails -ModuleName "az.accounts"
```

## PARAMETERS

### -ModuleName
The name of the module to look up

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

### System.Object
## NOTES
This was adapted from code by Matthew Dowst / @mdowst

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationModuleDetails.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationModuleDetails.md)

