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

<#foreach ($kort in $kortstokk) {
    Write-Output $kort
}

foreach ($kort in $kortstokk) {
    Write-Output "$($kort.suit[0])+$($kort.value)"
}#>

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




# Fra oppgave 5

### Regn ut den samlede poengsummen til kortstokk
#   Nummererte kort har poeng som angitt på kortet
#   Knekt (J), Dronning (Q) og Konge (K) teller som 10 poeng
#   Ess (A) teller som 11 poeng

# 1. - utgave - summen av poeng for kort er form for loop/iterere oppgave

$poengKortstokk = 0

# hva er forskjellen mellom -eq, ieg og ceq?
# # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.2

foreach ($kort in $kortstokk) {
    if ($kort.value -ceq 'J') {
        $poengKortstokk = $poengKortstokk + 10
    }
    elseif ($kort.value -ceq 'Q') {
        $poengKortstokk = $poengKortstokk + 10
    }
    elseif ($kort.value -ceq 'K') {
        $poengKortstokk = $poengKortstokk + 10
    }
    elseif ($kort.value -ceq 'A') {
        $poengKortstokk = $poengKortstokk + 11
    }
    else {
        $poengKortstokk = $poengkortstokk + $kort.value
    }
}

<#Write-Host "Poengsum: $poengKortstokk"#>

# 2. utgave - ønsker koden som en funksjon - hvorfor?

# https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.1

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"



# ...

# Tilordne 2 kort index 0 og index 1, til $meg. Dvs meg bestrakes som en kortstokk :-)

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..($kortstokk.Count - 1)]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..($kortstokk.count - 1)]

Write-Host "meg: $(kortstokktilstreng -kortstokk $meg)" 
Write-Host "magnus: $(kortstokktilstreng -kortstokk $magnus)"
Write-Host "kortstokk: $(kortstokktilstreng -kortstokk $kortstokk)"


# $megpoeng = sumPoengKortstokk [$meg]


# ...

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortstokkmMagnus) | $(kortstokktilstreng -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortStokkTilStreng -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if 
    # Sjekker først om begge har blackjack for da er det Draw
    ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack -and (sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner 'draw' -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif 
        # Sjekker om jeg har blackjack og skriver evt ut meg som vinner og begge deltakeres resultat
        ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
        skrivUtResultat -vinner 'meg' -kortStokkMagnus $magnus -kortStokkMeg $meg
        exit
}
elseif 
        # Sjekker om Magnus har blackjack og skriver evt ut Magnus som vinner og begge deltakeres resultat
        ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
        skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
        exit
}

# Hva er om begge har blackjack? Kanskje det kalles draw?
# frivillig - kan du endre koden til å ta hensyn til draw?