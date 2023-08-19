
if ($context = Get-AzContext) {
	$script:AztoolsLastSubscription = $context.Subscription
}
Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" | Foreach-Object { . $_.FullName }