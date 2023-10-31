---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md
schema: 2.0.0
---

# Get-AzToolsCostSummary

## SYNOPSIS

## SYNTAX

```
Get-AzToolsCostSummary [[-SubscriptionID] <String>] [[-StartDate] <String>] [[-EndDate] <String>]
 [[-CostMetric] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -SubscriptionID
Optional.

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

### -StartDate
Optional.
Default = 7 days ago

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $((Get-Date).AddDays(-7).ToString('yyyy-MM-dd'))
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Optional.
Default = Current date

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Get-Date).ToString('yyyy-MM-dd')
Accept pipeline input: False
Accept wildcard characters: False
```

### -CostMetric
PretaxCost or UsageQuantity
Cost metric to sum for total estimate cost
Default = UsageQuantity

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: UsageQuantity
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
I don't know.
No matter what I throw at this I don't seem to get back numbers
that match the portal.
I've tried Get-AzBilling\<abcdef\> cmdlets also, but none
seem to come close to the costs in the portal.
Maybe I need to inhale more paint
fumes or eat kitty litter or something.

## RELATED LINKS

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsCostSummary.md)

