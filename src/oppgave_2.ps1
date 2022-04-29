[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $Navn
)

# Hva er forskjell mellom '' og "" som begge er streng?
Write-Host "... $Navn!"
Write-Host '... $navn!'

Write-Host "... $navn!"
Write-Host '... $Navn!'


# Gir følgende resultat

#Navn: Akklebakkle
#... Akklebakkle!
#... $navn!
#... Akklebakkle!
#... $Navn!