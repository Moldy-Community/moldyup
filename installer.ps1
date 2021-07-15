
Write-Output "----------------------------------------------------------"
Write-Output "                      Moldy Installer                     "
Write-Output "----------------------------------------------------------"

function Download-Moldy{
    param(
        [string]$MoldyURL,
        [string]$MoldyInstallPath
    )
    Invoke-WebRequest -Uri $MoldyURL -OutFile $MoldyInstallPath
    Write-Output "Moldy Downloaded succesfuly"
    Write-Output "Go to $($MoldyInstallPath) and add this folder to the PATH and run refreshenv and test the installation with moldy -h"
}

$MoldyPath = Read-Host  -Prompt 'What path you want install moldy? (DEFAULT: $HOME\AppData\Local\moldy)'

if ($MoldyPath -eq $null -OR $MoldyPath -eq ''){
    $MoldyPath = Join-Path -Path $HOME -ChildPath 'AppData\Local\moldy'
}

Write-Output  'Path for the installation >> '$MoldyPath


$MoldyDownloadPath = Read-Host -Prompt 'You have a x86 (386 version) or x64(amd64 version) processor? (OPTIONS: 386 or amd64)'
Write-Output $MoldyDownloadPath
$MoldyDownloadPath = "https://github.com/Moldy-Community/moldy/releases/download/v0.2.0/moldy-v0.0.2_windows_$($MoldyDownloadPath).exe"
Download-Moldy -MoldyURL $MoldyDownloadPath -MoldyInstallPath $MoldyPath

Write-Output "Install a nerdfont for a best usage for Example Ubuntu Mono Nerd font"
$DownloadFont = Read-Host -Prompt "Download the recommended font ? (OPTIONS: Y and N)"
if ($DownloadFont -eq "y"){
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip" -OutFile "$(Join-Path -Path $HOME -ChildPath ".cache/fonts")"
    Write-Output  "Downloaded the font in $(Join-Path -Path $HOME -ChildPath ".cache\fonts") you can unzip and install manually"
}
