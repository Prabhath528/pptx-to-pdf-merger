Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "                PPTX to PDF Merger - Installation                " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# ── DEVELOPER DETAILS ──────────────────────────────────────────────────────────
Write-Host "  [+] Developer Details:" -ForegroundColor Green
Write-Host "      Name           : Mr. D.M. Prabhath Kelum Champika" -ForegroundColor White
Write-Host "      Designation    : CEO and Founder" -ForegroundColor White
Write-Host "      Company        : Pixel Forge Studio" -ForegroundColor White
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── LICENSE AGREEMENT ─────────────────────────────────────────────────────────
# (ඔයා පසුව දෙන ලින්ක් එකේ ඇති ලයිසන් විස්තර මෙතනට දාන්න පුළුවන්)
$LicenseText = @"
END USER LICENSE AGREEMENT (EULA)
---------------------------------
1. This software is provided 'as-is' without any warranty.
2. You agree not to decompile or misuse this utility.
3. All intellectual property belongs to Pixel Forge Studio.

Do you accept the terms of this license agreement?
"@

Write-Host $LicenseText -ForegroundColor Yellow
Write-Host ""

# පරිශීලකයාගෙන් අවසරය ඇසීම
$Choice = Read-Host "Type 'Y' to Accept and Install, or 'N' to Cancel"

if ($Choice -ne "Y" -and $Choice -ne "y") {
    Write-Host "`n[-] Installation cancelled. You must accept the license to install." -ForegroundColor Red
    Exit
}

Write-Host "`n[+] License accepted. Fetching components from server..." -ForegroundColor Green

# ── PATHS CONFIGURATION ───────────────────────────────────────────────────────
# (පියවර 2 කේදී ඔයා හදන ZIP ලින්ක් එක මෙතන "YOUR_ZIP_URL_HERE" වෙනුවට දාන්න)
$ZipUrl     = "https://github.com/Prabhath528/pptx-to-pdf-merger/releases/download/v0.0.1/app.zip" 
$TempZip    = "$env:TEMP\app_temp.zip"
$InstallDir = "$env:ProgramFiles\PPTX to PDF Merger"

# ── DOWNLOAD AND EXTRACT ──────────────────────────────────────────────────────
Write-Host "Downloading application files..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -ErrorAction Stop
} catch {
    Write-Host "ERROR: Failed to download the zip file. Check your internet or link." -ForegroundColor Red
    Exit
}

Write-Host "Extracting files to destination..." -ForegroundColor Gray
if (!(Test-Path $InstallDir)) { 
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null 
}
Expand-Archive -Path $TempZip -DestinationPath $InstallDir -Force
Remove-Item -Path $TempZip -Force 

# ── CREATE DESKTOP SHORTCUT ───────────────────────────────────────────────────
Write-Host "Creating Desktop shortcut..." -ForegroundColor Gray
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\PPTX to PDF Merger.lnk")
$Shortcut.TargetPath = "$InstallDir\main.exe"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Save()

Write-Host "`n[+] Installation completed successfully by Pixel Forge Studio!" -ForegroundColor Green
Write-Host "[+] You can now run the app from your Desktop." -ForegroundColor Green
