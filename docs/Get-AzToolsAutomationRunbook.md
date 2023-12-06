---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbook.md
schema: 2.0.0
---

# Get-AzToolsAutomationRunbook

## SYNOPSIS
Get Azure Automation Runbooks

## SYNTAX

```
Get-AzToolsAutomationRunbook [-SelectContext] [[-Filter] <String>] [[-TagName] <String>] [[-TagValue] <String>]
 [-Export] [[-ExportPath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get and/or export Azure Automation Runbooks

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationRunbook
```

Returns all runbooks in the active Automation Account

### EXAMPLE 2
```
Get-AzToolsAutomationRunbook -Filter "UserAccount*"
```

Returns runbooks where the name begins with 'UserAccount'

### EXAMPLE 3
```
Get-AzToolsAutomationRunbook -TagName "RunOn" -TagValue "Azure"
```

Returns runbooks which have tag "RunOn" assigned to value "Azure"

### EXAMPLE 4
```
Get-AzToolsAutomationRunbook -SelectContext
```

Prompts to select the Subscription, ResourceGroup, AutomationAccount and then
returns all runbooks in the selected Automation Account.

### EXAMPLE 5
```
Get-AzToolsAutomationRunbook -Export -ExportPath "c:\temp"
```

Exports runbooks to files under "c:\temp"

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

### -Filter
Optional.
Filter runbooks by name pattern.
Default = "*" (all matching)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -TagName
Optional.
Name of Tag to filter results.

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

### -TagValue
Optional.
If TagName is provided, filters the results to matching tag and value
If not provided with TagName, then results are filtered to return runbooks
which have Tag \[TagName\] regardless of the value assigned to the tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Export
Optional.
Save runbooks to local path

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

### -ExportPath
Optional.
If -Export is used, specifies the path where runbook files will be saved.
Default is current user profile "desktop" path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$($env:USERPROFILE)\desktop"
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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbook.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationRunbook.md)

