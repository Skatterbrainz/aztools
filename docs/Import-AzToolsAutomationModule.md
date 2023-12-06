---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsAutomationModule.md
schema: 2.0.0
---

# Import-AzToolsAutomationModule

## SYNOPSIS
Import a PowerShell module into an Azure Automation Account

## SYNTAX

```
Import-AzToolsAutomationModule [-ModuleName] <String> [[-ModuleVersion] <String>] [-SelectContext]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Import or Update a PowerShell module into an Azure Automation Account

## EXAMPLES

### EXAMPLE 1
```
Import-AzAutomationToolsModule -ModuleName az.accounts
```

Imports current/latest version from the PowerShell Gallery

### EXAMPLE 2
```
Import-AzToolsAutomationModule -ModuleName az.accounts -ModuleVersion 2.12.1
```

Imports version 2.12.1 from the PowerShell Gallery

## PARAMETERS

### -ModuleName
Name of module in PowerShell Gallery

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

### -ModuleVersion
Optional.
Version to be imported.
If not provided, the latest/current version is imported

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

### Microsoft.Azure.Commands.Automation.Model.Module
## NOTES

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsAutomationModule.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsAutomationModule.md)

