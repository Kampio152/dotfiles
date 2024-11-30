# Setup script
#Requires -RunAsAdministrator

# Linked Files
$symlinks = @{
    "$HOME\.gitconfig"                                                                              = ".\.gitconfig"
    "$HOME\.gitignore_global"                                                                              = ".\.gitignore_global"
    "$HOME\OneDrive\Dokumenty\PowerShell\Microsoft.PowerShell_profile.ps1"                          = ".\extra\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\extra\WindowsTerminal\WindowsTerminalConfig.json"
    "$HOME\starship.toml"                                                                           = ".\extra\Starship\starship.toml"
}

# Winget
$wingetDeps = @(
    "Microsoft.PowerShell",
    "Git.Git",
    "GitHub.cli",
    "Microsoft.VisualStudioCode",
    "Microsoft.PowerToys",
    "Spotify.Spotify",
    "OpenJS.NodeJS",
    "Yarn.Yarn",
    "Starship.Starship",
    "Logitech.GHUB",
    "Valve.Steam",
    "EpicGames.EpicGamesLauncher",
    "GOG.Galaxy",
    "ElectronicArts.EADesktop",
    "UbiquitiInc.WiFimanDesktop",
    "Discord.Discord.Development",
    "Wargaming.GameCenter",
    "Proton.ProtonMail",
    "Proton.ProtonPass",
    "Proton.ProtonDrive"
)

Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing Missing Dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch $wingetDep) {
        winget install -e --id $wingetDep
    } else {
        Write-Host $wingetDep
    }
}

$currentGitEmail = (git config --global user.email)
$currentGitName = (git config --global user.name)

Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
    Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}

git config --global --unset user.email | Out-Null
git config --global --unset user.name | Out-Null
git config --global user.email $currentGitEmail | Out-Null
git config --global user.name $currentGitName | Out-Null

# Uninstall Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

Write-Host "Skonczone process"
