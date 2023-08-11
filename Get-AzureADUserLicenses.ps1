$TerminatedUsers = Get-AzureAdUser -All | Where {$_.AccountEnabled -eq $False}

# E3 = ENTERPRISEPACK = Office 365 E3  / Microsoft 365 E3
# E5 = ENTERPRISEPREMIUM = Office 365 E5 / Microsoft 365 E5
# P1 = AAD_PREMIUM = Azure Active Directory Premium P1
# F3 = DESKLESSPACK = Office 365 F3

foreach ($user in $TerminatedUsers) {
	$e3 = $null; $e5 = $null; $f3 = $null; $p1 = $null
	$upn = $user.UserPrincipalName
	$licenses = Get-AzureADUserLicenseDetail -ObjectId $upn
	$skuPartNums = $licenses.SkuPartNumber
	if ('SPE_E3' -in $skuPartNums) { $e3 = $true }
	if ('ENTERPRISEPACK' -in $skuPartNums) { $e3 = $true }
	if ('ENTERPRSEPREMIUM' -in $skuPartNums) { $e5 = $true }
	if ('DESKLESSPACK' -in $skuPartNums) { $f3 = $true }
	if ('AAD_PREMIUM' -in $skuPartNums) { $p1 = $true }
	[pscustomobject]@{
		UserId = $upn
		E3 = $e3
		E5 = $e5
		F3 = $f3
		P1 = $p1
	}
}