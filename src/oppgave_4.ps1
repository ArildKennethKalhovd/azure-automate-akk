[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når paramater ikke er gitt brukes default verdi
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

# For en enkel feilhåndtering, se bruk av $ErrorActionPreference i hint til oppg 3
# For mer spesifikk feilhåndtering, søk opp bruk av try{} catch{} i PowerShell på Google

# resten av koden er som oppgave 3




$ErrorActionPreference = 'Stop'

<# $webRequest = Invoke-WebRequest -Uri "http://nav-deckofcards.herokuapp.com/shuffle" #>

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

foreach ($kort in $kortstokk) {
    Write-Output $kort
}

foreach ($kort in $kortstokk) {
    Write-Output "$($kort.suit[0])+$($kort.value)"
}

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)" + ","
    }
    return $streng
}

Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"

<# 

sjekke f.eks. $kort[-1] ikke er lik $kort 

$kortstokk.count og bruke IF

#>

