# Module manifest for module 'aztools'
# Generated by: Skatterbrainz
# Generated on: 9/11/2023
# Modified on: 05/06/2024
@{
RootModule = '.\aztools.psm1'
ModuleVersion = '1.0.11'
# CompatiblePSEditions = @()
GUID = 'acdf46e8-6060-4db9-91bc-e41cd19957c4'
Author = 'Skatterbrainz'
CompanyName = 'Some dude named Dave'
Copyright = '(c) Skatterbrainz. All rights reserved.'
Description = 'Azure PowerShell Tools'
# PowerShellVersion = '5.1'
# PowerShellHostName = ''
# PowerShellHostVersion = '5.1'
# DotNetFrameworkVersion = ''
# ClrVersion = ''
# ProcessorArchitecture = ''
RequiredModules = @(
	'az.accounts','az.compute','az.storage','az.automation',
	'az.operationalinsights','az.PolicyInsights','az.monitor'
)
# RequiredAssemblies = @()
# ScriptsToProcess = @()
# TypesToProcess = @()
# FormatsToProcess = @()
# NestedModules = @()
FunctionsToExport = '*'
CmdletsToExport = '*'
VariablesToExport = '*'
AliasesToExport = '*'
# DscResourcesToExport = @()
# ModuleList = @()
# FileList = @()
PrivateData = @{
    PSData = @{
        Tags = @('skatterbrainz','aztools','azure','accounts','compute','automation','runbooks','modules','storage','context','jobs','vm','runcommand')
        LicenseUri = 'https://github.com/Skatterbrainz/aztools/blob/main/LICENSE'
        ProjectUri = 'https://github.com/Skatterbrainz/aztools'
        IconUri = 'https://github.com/Skatterbrainz/aztools/assets/11505001/7404bc9e-443c-44a5-91ac-e6cbe7d61153'
        # ReleaseNotes = ''
        # Prerelease = ''
        RequireLicenseAcceptance = $false
        # ExternalModuleDependencies = @()
    }
}
# HelpInfoURI = ''
# DefaultCommandPrefix = ''
}
