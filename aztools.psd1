# Module manifest for module 'aztools'
# Generated by: Skatterbrainz
# Generated on: 8/18/2023
@{
RootModule = '.\aztools.psm1'
ModuleVersion = '0.0.3'
# CompatiblePSEditions = @()
GUID = 'acdf46e8-6060-4db9-91bc-e41cd19957c4'
Author = 'Skatterbrainz'
CompanyName = 'Skattered McBrainz'
Copyright = '(c) Skatterbrainz. All rights reserved.'
Description = 'Azure PowerShell Tools'
PowerShellVersion = '7.3'
# PowerShellHostName = ''
PowerShellHostVersion = '7.3'
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
        Tags = @('aztools','azure','accounts','skatterbrainz')
        # LicenseUri = ''
        ProjectUri = 'https://github.com/Skatterbrainz/aztools'
        # IconUri = ''
        # ReleaseNotes = ''
        Prerelease = 'alpha'
        # RequireLicenseAcceptance = $false
        # ExternalModuleDependencies = @()
    }
}
# HelpInfoURI = ''
# DefaultCommandPrefix = ''
}
