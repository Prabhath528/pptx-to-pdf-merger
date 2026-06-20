param(
    [switch]$Force   # Skip the version check and re-download/overwrite regardless
)

# =============================================================================
#   PPTX to PDF Merger - Online Updater
#   Developer : Mr. D.M. Prabhath Kelum Champika
#   Company   : Pixel Forge Studio
#   Version   : V 0.0.1
#   Website   : https://pixelforgestudioprabhath.netlify.app
# =============================================================================

# ── PATHS / SOURCE CONFIGURATION (must match online_install.ps1) ─────────────
$InstallDir    = "$env:ProgramFiles\PPTX to PDF Merger"
$ShortcutPath  = "$env:USERPROFILE\Desktop\PPTX to PDF Merger.lnk"
$ProcessName   = "main"
$VersionFile   = "$InstallDir\version.txt"
$TempZip       = "$env:TEMP\app_update_temp.zip"
$RepoApiUrl    = "https://api.github.com/repos/Prabhath528/pptx-to-pdf-merger/releases/latest"

# ── ADMIN CHECK ────────────────────────────────────────────────────────────────
# Program Files requires elevated rights to write/overwrite into.
function Test-IsAdmin {
    $id        = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($id)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Host "[-] This script must be run as Administrator." -ForegroundColor Red
    Write-Host "    Right-click update.ps1  ->  Run with PowerShell (as Administrator)." -ForegroundColor Yellow
    Exit
}

# ── CONSOLE HEADER ────────────────────────────────────────────────────────────
Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "             PPTX to PDF Merger  -  Online Updater                " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# ── CHECK INSTALLATION EXISTS ─────────────────────────────────────────────────
if (!(Test-Path $InstallDir)) {
    Write-Host "  [-] No existing installation found at:" -ForegroundColor Yellow
    Write-Host "      $InstallDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please run the installer (online_install.ps1) first." -ForegroundColor Gray
    Write-Host ""
    Exit
}

Write-Host "  [+] Found installation at:" -ForegroundColor Green
Write-Host "      $InstallDir" -ForegroundColor White
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── READ CURRENTLY INSTALLED VERSION ──────────────────────────────────────────
# Older installs (done before this updater existed) won't have a version.txt
# yet -- treated as "unknown", so the first update always proceeds.
$CurrentVersion = if (Test-Path $VersionFile) {
    (Get-Content $VersionFile -Raw).Trim()
} else {
    "unknown"
}
Write-Host "  Installed version : $CurrentVersion" -ForegroundColor White

# ── CHECK LATEST VERSION ON GITHUB ────────────────────────────────────────────
Write-Host "Checking GitHub for the latest release..." -ForegroundColor Gray
try {
    $Release = Invoke-RestMethod -Uri $RepoApiUrl -Headers @{ "User-Agent" = "PixelForgeStudio-Updater" } -ErrorAction Stop
    $LatestVersion = $Release.tag_name
} catch {
    Write-Host "  [-] ERROR: Could not check for updates. Check your internet connection." -ForegroundColor Red
    Exit
}
Write-Host "  Latest version    : $LatestVersion" -ForegroundColor White
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── COMPARE VERSIONS ───────────────────────────────────────────────────────────
if (-not $Force -and $CurrentVersion -eq $LatestVersion) {
    Write-Host "  [+] You already have the latest version ($LatestVersion)." -ForegroundColor Green
    Write-Host "      Nothing to do. (Use -Force to reinstall it anyway.)" -ForegroundColor Gray
    Write-Host ""
    Exit
}

Write-Host "[+] Update available -> $LatestVersion. Proceeding..." -ForegroundColor Green
Write-Host ""

# ── DOWNLOAD URL FOR THE NEW RELEASE ──────────────────────────────────────────
# Same fixed asset name ("app.zip") used by online_install.ps1's releases.
$ZipUrl = "https://github.com/Prabhath528/pptx-to-pdf-merger/releases/download/v0.0.2/pptx-to-pdf-merger.zip"

# ── CLOSE RUNNING APP (IF OPEN) ───────────────────────────────────────────────
Write-Host "Checking for running instances..." -ForegroundColor Gray
$RunningProc = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
if ($RunningProc) {
    try {
        $RunningProc | Stop-Process -Force -ErrorAction Stop
        Write-Host "  [+] Closed running instance of the app." -ForegroundColor Green
        Start-Sleep -Milliseconds 500
    } catch {
        Write-Host "  [-] Could not close the app automatically." -ForegroundColor Red
        Write-Host "      Please close it manually and re-run this updater." -ForegroundColor Red
        Exit
    }
}

# ── DOWNLOAD AND EXTRACT (OVERWRITE IN PLACE) ─────────────────────────────────
Write-Host "Downloading update..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -ErrorAction Stop
} catch {
    Write-Host "  [-] ERROR: Failed to download the update." -ForegroundColor Red
    Write-Host "      Check your internet connection or that $LatestVersion has an app.zip asset." -ForegroundColor Red
    Exit
}

Write-Host "Installing update..." -ForegroundColor Gray
try {
    Expand-Archive -Path $TempZip -DestinationPath $InstallDir -Force -ErrorAction Stop
} catch {
    Write-Host "  [-] ERROR: Failed to extract the update." -ForegroundColor Red
    Write-Host "      Some files may still be in use. Close the app and try again." -ForegroundColor Red
    Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
    Exit
}
Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue

# ── RECORD THE NEW VERSION ────────────────────────────────────────────────────
Set-Content -Path $VersionFile -Value $LatestVersion -Force

# ── RECREATE DESKTOP SHORTCUT (in case it was missing) ────────────────────────
Write-Host "Refreshing Desktop shortcut..." -ForegroundColor Gray
$WshShell                 = New-Object -ComObject WScript.Shell
$Shortcut                 = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath       = "$InstallDir\main.exe"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Save()

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  [+] Update completed successfully!                             " -ForegroundColor Green
Write-Host "  [+] Now running version : $LatestVersion" -ForegroundColor Green
Write-Host "  [+] Developed by Pixel Forge Studio  -  pixelforgestudioprabhath.netlify.app" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""