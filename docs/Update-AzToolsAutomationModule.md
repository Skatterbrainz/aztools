---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Update-AzToolsAutomationModule.md
schema: 2.0.0
---

# Update-AzToolsAutomationModule

## SYNOPSIS
Update PowerShell module in Azure Automation Account

## SYNTAX

```
Update-AzToolsAutomationModule [-Name] <String> [-UpdateModule] [-SelectContext]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Update PowerShell module in Azure Automation Account

## EXAMPLES

### EXAMPLE 1
```
Update-AzToolsAutomationModule -Name ExchangeOnlineManagement
```

### EXAMPLE 2
```
Update-AzToolsAutomationModule -Name ExchangeOnlineManagement -UpdateModule
```

## PARAMETERS

### -Name
Required.
Name of PowerShell Module

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

### -UpdateModule
Optional.
Force update of module (safety switch)
Default (if not used) is to show current and latest versions for comparison only (no changes/updates applied)

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
This function is heavily adapted from code written by Matthew Dowst (@mdowst), I just made miniscule tweaks to fit this module

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Update-AzToolsAutomationModule.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Update-AzToolsAutomationModule.md)

