---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md
schema: 2.0.0
---

# Get-AzToolsCostSummary

## SYNOPSIS
Get Billing Invoice Summary

## SYNTAX

```
Get-AzToolsCostSummary [-SelectContext] [-Latest] [<CommonParameters>]
```

## DESCRIPTION
Get Billing Invoice Summary for Azure Billing Account

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsCostSummary
```

Returns all available invoices for the current Azure context.

### EXAMPLE 2
```
Get-AzToolsCostSummary -SelectContext
```

Prompts to select Azure context, then returns all available invoices.

### EXAMPLE 3
```
Get-AzToolsCostSummary -Latest
```

Returns the latest invoice only.

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

### -Latest
Optional.
Return the latest invoice only.
Default is to return all available invoices.

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md)

