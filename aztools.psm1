
#if ($context = Get-AzContext) {
#	$script:AztoolsLastSubscription = $context.Subscription
#}
("private","public") | Foreach-Object {
	Get-ChildItem -Path "$(Join-Path $PSScriptRoot $_)" -Filter "*.ps1" | Foreach-Object {
		Write-Host "Command: $($_.BaseName)"
		. $_.FullName
	}
}