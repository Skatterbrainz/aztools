---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsVm.md
schema: 2.0.0
---

# Get-AzToolsVm

## SYNOPSIS
Get Azure Virtual Machines by searching on Tag name/value or Extension

## SYNTAX

```
Get-AzToolsVm [-TagName] <String> [[-TagValue] <String>] [-SelectContext] [-AllSubscriptions]
 [[-SubscriptionId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get Azure Virtual Machines by searching on Tag name/value or Extension

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsVm -TagName "PatchGroup" -TagValue "Group2"
```

Returns all VM's in the current subscription which have tag "PatchGroup" assigned with value "Group2"

### EXAMPLE 2
```
Get-AzToolsVm -TagName "PatchGroup" -TagValue "Group2" -AllSubscriptions
```

Returns all VM's in all subscriptions which have tag "PatchGroup" assign with value "Group2"

### EXAMPLE 3
```
Get-AzToolsVm -TagName "PatchGroup" -AllSubscriptions
```

Returns all VM's in all subscriptions which have tag "PatchGroup" assigned with any value,
sorted by tag value first, then by machine name

### EXAMPLE 4
```
Get-AzToolsVm -TagName "PatchGroup" -AllSubscription | Select-Object PatchGroup,Name,OSName,PowerState
```

Example showing some common properties to return for viewing or processing, something like this:

\`\`\`
PatchGroup Name               OsName                                       PowerState
---------- ----               ------                                       ----------
Group1     AZEVMCTXA01        Windows Server 2016 Standard                 VM running
Group1     AZEVMCTXA03        Windows Server 2016 Datacenter               VM running
Group1     AZEVMCTXDB02       Windows Server 2016 Standard                 VM running
Group1     AZDEVCXDB04                                                     VM deallocated
Group2     AZEPRODAW01        Windows Server 2016 Standard                 VM running
Group2     AZEPRODAW02        Windows Server 2016 Datacenter               VM running
Group2     AZEPRODDB01        Windows Server 2016 Datacenter               VM running
\`\`\`

## PARAMETERS

### -TagName
Optional.
Tag name to search for

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

### -TagValue
Required if -TagName is used.
Value assigned to TagName to filter on

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

### -AllSubscriptions
Optional.
Enumerate machines in all subscriptions.
Default = Enumerate machines in the current/active context subscription only.

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

### -SubscriptionId
Optional.
Limits scope to subscription with matching Id only.
If AllSubscriptions is used, this is ignored.

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsVm.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsVm.md)

