Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" | Foreach-Object { . $_.FullName }