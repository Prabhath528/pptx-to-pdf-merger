# =============================================================================
#   PPTX to PDF Merger - Uninstaller
#   Developer : Mr. D.M. Prabhath Kelum Champika
#   Company   : Pixel Forge Studio
#   Version   : V 0.0.1
#   Website   : https://pixelforgestudioprabhath.netlify.app
# =============================================================================

# ── PATHS CONFIGURATION (must match online_install.ps1) ──────────────────────
$InstallDir   = "$env:ProgramFiles\PPTX to PDF Merger"
$ShortcutPath = "$env:USERPROFILE\Desktop\PPTX to PDF Merger.lnk"
$ProcessName  = "main"

# ── ADMIN CHECK ────────────────────────────────────────────────────────────────
# Program Files requires elevated rights to delete from.
function Test-IsAdmin {
    $id        = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($id)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Host "[-] This script must be run as Administrator." -ForegroundColor Red
    Write-Host "    Right-click uninstall.ps1  ->  Run with PowerShell (as Administrator)." -ForegroundColor Yellow
    Exit
}

# ── CONSOLE HEADER ────────────────────────────────────────────────────────────
Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "             PPTX to PDF Merger  -  Uninstaller                  " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# ── CHECK INSTALLATION EXISTS ─────────────────────────────────────────────────
if (!(Test-Path $InstallDir)) {
    Write-Host "  [-] No installation found at:" -ForegroundColor Yellow
    Write-Host "      $InstallDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Nothing to uninstall." -ForegroundColor Gray
    Write-Host ""
    Exit
}

Write-Host "  [+] Found installation at:" -ForegroundColor Green
Write-Host "      $InstallDir" -ForegroundColor White
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── CONFIRMATION ───────────────────────────────────────────────────────────────
$Choice = Read-Host "Are you sure you want to uninstall PPTX to PDF Merger? (Type 'Y' to Confirm / 'N' to Cancel)"

if ($Choice -ne "Y" -and $Choice -ne "y") {
    Write-Host "`n[-] Uninstall cancelled." -ForegroundColor Red
    Exit
}

Write-Host ""

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
        Write-Host "      Please close it manually and re-run this uninstaller." -ForegroundColor Red
        Exit
    }
} else {
    Write-Host "  [+] App is not running." -ForegroundColor Green
}

# ── REMOVE DESKTOP SHORTCUT ───────────────────────────────────────────────────
Write-Host "Removing Desktop shortcut..." -ForegroundColor Gray
if (Test-Path $ShortcutPath) {
    try {
        Remove-Item $ShortcutPath -Force -ErrorAction Stop
        Write-Host "  [+] Shortcut removed." -ForegroundColor Green
    } catch {
        Write-Host "  [-] Warning: could not remove the desktop shortcut." -ForegroundColor Yellow
    }
} else {
    Write-Host "  [+] No shortcut found (already removed)." -ForegroundColor Green
}

# ── REMOVE INSTALL DIRECTORY ──────────────────────────────────────────────────
Write-Host "Removing application files..." -ForegroundColor Gray
try {
    Remove-Item -Path $InstallDir -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host "  [-] ERROR: Failed to remove $InstallDir." -ForegroundColor Red
    Write-Host "      Some files may still be in use. Close the app and try again," -ForegroundColor Red
    Write-Host "      or delete the folder manually." -ForegroundColor Red
    Exit
}

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  [+] Uninstall completed successfully!                          " -ForegroundColor Green
Write-Host "  [+] PPTX to PDF Merger has been removed from this device.      " -ForegroundColor Green
Write-Host "  [+] Developed by Pixel Forge Studio  -  pixelforgestudioprabhath.netlify.app" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""