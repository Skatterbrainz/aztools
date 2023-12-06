---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Remove-AzToolsContext.md
schema: 2.0.0
---

# Remove-AzToolsContext

## SYNOPSIS
Remove selected Azure Az Context sessions

## SYNTAX

```
Remove-AzToolsContext [-NoConfirm] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Remove select Azure AzContext sessions for current user

## EXAMPLES

### EXAMPLE 1
```
Remove-AzToolsContext
Displays a gridview to select context objects to remove, then prompts for confirmation on each before removing
```

### EXAMPLE 2
```
Remove-AzToolsContext -NoConfirm
Displays a gridview to select context objects to remove, then removes each without confirmation
```

## PARAMETERS

### -NoConfirm
Do not prompt for confirmation on each selectec context

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Remove-AzToolsContext.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Remove-AzToolsContext.md)

