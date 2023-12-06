---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsModuleVersionCheck.md
schema: 2.0.0
---

# Invoke-AzToolsModuleVersionCheck

## SYNOPSIS
Checks if the module already exists in the Automation Account and if it an equal or greater version

## SYNTAX

```
Invoke-AzToolsModuleVersionCheck [-ModuleName] <String> [-MinimumVersion] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-AzToolsModuleVersionCheck -ModuleName "az.accounts" -MinimumVersion "2.12.1"
```

## PARAMETERS

### -ModuleName
The name of the module to check for

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

### -MinimumVersion
The minimum required version of the module to check for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.Boolean
## NOTES
This was adapted from code by Matthew Dowst / @mdowst

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsModuleVersionCheck.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Import-AzToolsModuleVersionCheck.md)

