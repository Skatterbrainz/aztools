---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Switch-AzToolsContext.md
schema: 2.0.0
---

# Switch-AzToolsContext

## SYNOPSIS
Switch between Azure Contexts

## SYNTAX

```
Switch-AzToolsContext [[-Name] <String>] [-List] [<CommonParameters>]
```

## DESCRIPTION
Switch between Azure contexts using a PowerShell Gridview menu

## EXAMPLES

### EXAMPLE 1
```
Switch-AztContext
```

### EXAMPLE 2
```
Switch-AzToolsContext -name "contoso"
```

## PARAMETERS

### -Name
Name of Context.
If omitted, it will display a GridView to choose the target context

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

### -List
List all defined Az Contexts on current system/session

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Switch-AzToolsContext.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Switch-AzToolsContext.md)

