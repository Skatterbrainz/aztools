---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsStorageUsage.md
schema: 2.0.0
---

# Get-AzToolsStorageUsage

## SYNOPSIS
Get Azure Storage Account summary information

## SYNTAX

```
Get-AzToolsStorageUsage [[-Name] <String>] [-SelectContext] [[-Scope] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get Azure Storage Account container size and space used

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsStorageUsage -Scope AllSubscriptions
```

### EXAMPLE 2
```
Get-AzToolsStorageUsage -Name "sa123456xyz"
```

## PARAMETERS

### -Name
Optional.
Name of Storage Account

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

### -Scope
Optional.
Limit search to either Current Subscription or All Subscription (within the tenant)
Default = CurrentSubscription

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: CurrentSubscription
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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsStorageUsage.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsStorageUsage.md)

