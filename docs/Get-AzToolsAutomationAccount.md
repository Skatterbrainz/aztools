---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationAccount.md
schema: 2.0.0
---

# Get-AzToolsAutomationAccount

## SYNOPSIS
Display summary information for Azure Automation Account

## SYNTAX

```
Get-AzToolsAutomationAccount [-SelectContext] [-Detailed] [<CommonParameters>]
```

## DESCRIPTION
Returns summary information about an Azure Automation Account, including
Automation Account name, Resource Group, Location, Plan, Tags, and counts of
assets such as Runbooks, Variables and Credentials.
If -Detailed is used, the
primary key, secondary key and endpoint information is returned also.

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationAccount
```

### EXAMPLE 2
```
Get-AzToolsAutomationAccount -Detailed
```

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

### -Detailed
Optional.
Includes information for the Primary Key, Secondary Key and Endpoint URI

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationAccount.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationAccount.md)

