---
external help file: aztools-help.xml
Module Name: aztools
online version: https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobs.md
schema: 2.0.0
---

# Get-AzToolsAutomationJobs

## SYNOPSIS
Get Azure Automation Account runbook jobs

## SYNTAX

```
Get-AzToolsAutomationJobs [-SelectContext] [[-JobID] <Guid>] [[-JobStatus] <String>] [[-StartTime] <DateTime>]
 [[-EndTime] <DateTime>] [[-RunbookName] <String>] [-SelectRunbook] [-ShowOutput] [[-ShowLimit] <Int32>]
 [-StopProcessing] [<CommonParameters>]
```

## DESCRIPTION
Get Azure Automation Account runbook jobs

## EXAMPLES

### EXAMPLE 1
```
Get-AzToolsAutomationJobs -JobStatus Failed
```

### EXAMPLE 2
```
Get-AzToolsAutomationJobs -JobStatus Failed -RunbookName "MyRunbook"
```

### EXAMPLE 3
```
Get-AzToolsAutomationJobs -JobStatus Suspended -RunbookName "MyRunbook" -StopProcessing
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

### -JobID
GUID for Automation Job

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobStatus
Optional.
Job Status type:
Activating, Completed, Failed,Queued,Resuming, Running, Starting, Stopped, Stopping, Suspended, Suspending
Default = Running

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Running
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
Optional.
Filter jobs starting after \[StartTime\] (date and time)

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
Optional.
Filter jobs with status prior to \[EndTime\] (date and time)

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunbookName
Optional.
Filter jobs related to a specific Runbook

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelectRunbook
Optional.
Prompt for Runbook using gridview

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

### -ShowOutput
Optional.
Send Jobs to Get-AzToolsJobOutput for more detailed information

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

### -ShowLimit
Optional.
Limit number of jobs to show when using -ShowOutput
Default = 10

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopProcessing
Optional.
Stops jobs returned from query \[only if\] the JobStatus parameter is "Suspended"

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

[https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobs.md](https://github.com/Skatterbrainz/aztools/tree/main/docs/Get-AzToolsAutomationJobs.md)

