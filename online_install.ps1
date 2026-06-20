
# =============================================================================
#   PPTX to PDF Merger - Online Installer
#   Developer : Mr. D.M. Prabhath Kelum Champika
#   Company   : Pixel Forge Studio
#   Version   : V 0.0.1
#   Website   : https://pixelforgestudioprabhath.netlify.app
# =============================================================================

# ── BRANDED SPLASH SCREEN (Windows Forms with Logo) ───────────────────────────
# Displays the Logo.png as a splash window before the console flow begins.
# Auto-closes after 3.5 seconds. Gracefully skips if WinForms is unavailable.

function Show-InstallerBanner {
    try {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        # ── Create form ──
        $form                  = New-Object System.Windows.Forms.Form
        $form.Text             = "PPTX to PDF Merger  –  V 0.0.1"
        $form.ClientSize       = New-Object System.Drawing.Size(420, 285)
        $form.StartPosition    = [System.Windows.Forms.FormStartPosition]::CenterScreen
        $form.FormBorderStyle  = [System.Windows.Forms.FormBorderStyle]::FixedSingle
        $form.MaximizeBox      = $false
        $form.MinimizeBox      = $false
        $form.TopMost          = $true
        $form.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#0b1120")

        # Outer accent border (2 px)
        $outerBorder           = New-Object System.Windows.Forms.Panel
        $outerBorder.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1e3f78")
        $outerBorder.Dock      = [System.Windows.Forms.DockStyle]::Fill
        $form.Controls.Add($outerBorder)

        # Inner dark panel (inset by 2 px)
        $inner              = New-Object System.Windows.Forms.Panel
        $inner.BackColor    = [System.Drawing.ColorTranslator]::FromHtml("#0b1120")
        $inner.Size         = New-Object System.Drawing.Size(416, 281)
        $inner.Location     = New-Object System.Drawing.Point(2, 2)
        $outerBorder.Controls.Add($inner)

        # ── Logo image ──
        # Priority: (1) logo.png in same folder as script
        #           (2) download from website
        #           (3) text-based fallback icon

        $tempLogoPath = "$env:TEMP\pfs_splash_$(Get-Random).png"
        $imgObj       = $null
        $logoLoaded   = $false

        # Try local file first
        $scriptFolder = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
        $localLogoPath = Join-Path $scriptFolder "Logo.png"
        if (-not (Test-Path $localLogoPath)) {
            $localLogoPath = Join-Path $scriptFolder "logo.png"
        }

        if (Test-Path $localLogoPath) {
            try {
                Copy-Item $localLogoPath $tempLogoPath -Force -ErrorAction Stop
                $imgObj     = [System.Drawing.Image]::FromFile($tempLogoPath)
                $logoLoaded = $true
            } catch { $logoLoaded = $false }
        }

        # Fallback: download from website
        if (-not $logoLoaded) {
            try {
                Invoke-WebRequest `
                    -Uri        "https://pixelforgestudioprabhath.netlify.app/Logo.png" `
                    -OutFile    $tempLogoPath `
                    -TimeoutSec 6 `
                    -UseBasicParsing `
                    -ErrorAction Stop
                $imgObj     = [System.Drawing.Image]::FromFile($tempLogoPath)
                $logoLoaded = $true
            } catch { $logoLoaded = $false }
        }

        if ($logoLoaded -and $imgObj) {
            $picBox          = New-Object System.Windows.Forms.PictureBox
            $picBox.Image    = $imgObj
            $picBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
            $picBox.Size     = New-Object System.Drawing.Size(90, 90)
            $picBox.Location = New-Object System.Drawing.Point(163, 20)
            $picBox.BackColor = [System.Drawing.Color]::Transparent
            $inner.Controls.Add($picBox)
        } else {
            # Text-based fallback icon
            $iconFrame           = New-Object System.Windows.Forms.Label
            $iconFrame.Text      = "P→F"
            $iconFrame.Font      = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $iconFrame.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#3b82f6")
            $iconFrame.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#112240")
            $iconFrame.Size      = New-Object System.Drawing.Size(90, 90)
            $iconFrame.Location  = New-Object System.Drawing.Point(163, 20)
            $iconFrame.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
            $inner.Controls.Add($iconFrame)
        }

        # ── Labels ──

        # App name
        $lblApp           = New-Object System.Windows.Forms.Label
        $lblApp.Text      = "PPTX  to  PDF  Merger"
        $lblApp.Font      = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
        $lblApp.ForeColor = [System.Drawing.Color]::White
        $lblApp.AutoSize  = $false
        $lblApp.Size      = New-Object System.Drawing.Size(400, 32)
        $lblApp.Location  = New-Object System.Drawing.Point(10, 122)
        $lblApp.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $inner.Controls.Add($lblApp)

        # Version + Studio
        $lblVer           = New-Object System.Windows.Forms.Label
        $lblVer.Text      = "V 0.0.1   |   Pixel Forge Studio"
        $lblVer.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
        $lblVer.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#93c5fd")
        $lblVer.AutoSize  = $false
        $lblVer.Size      = New-Object System.Drawing.Size(400, 24)
        $lblVer.Location  = New-Object System.Drawing.Point(10, 160)
        $lblVer.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $inner.Controls.Add($lblVer)

        # Developer credit
        $lblDev           = New-Object System.Windows.Forms.Label
        $lblDev.Text      = "Developed by  Mr. D.M. Prabhath Kelum Champika"
        $lblDev.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
        $lblDev.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#4b6584")
        $lblDev.AutoSize  = $false
        $lblDev.Size      = New-Object System.Drawing.Size(400, 22)
        $lblDev.Location  = New-Object System.Drawing.Point(10, 190)
        $lblDev.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $inner.Controls.Add($lblDev)

        # ── Bottom status bar ──
        $statusBar           = New-Object System.Windows.Forms.Panel
        $statusBar.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#172a4a")
        $statusBar.Size      = New-Object System.Drawing.Size(416, 48)
        $statusBar.Location  = New-Object System.Drawing.Point(0, 233)
        $inner.Controls.Add($statusBar)

        $lblStatus           = New-Object System.Windows.Forms.Label
        $lblStatus.Text      = "Initializing installer  •  Please wait..."
        $lblStatus.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
        $lblStatus.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#64748b")
        $lblStatus.AutoSize  = $false
        $lblStatus.Size      = New-Object System.Drawing.Size(400, 48)
        $lblStatus.Location  = New-Object System.Drawing.Point(8, 0)
        $lblStatus.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $statusBar.Controls.Add($lblStatus)

        # ── Auto-close timer (3.5 s) ──
        $timer          = New-Object System.Windows.Forms.Timer
        $timer.Interval = 3500
        $timer.Add_Tick({
            $timer.Stop()
            $form.Close()
        })
        $timer.Start()

        [void]$form.ShowDialog()    # Blocks until timer closes it

        # ── Cleanup ──
        if ($imgObj  -ne $null) { try { $imgObj.Dispose()  } catch {} }
        if ($form    -ne $null) { try { $form.Dispose()    } catch {} }
        if ($timer   -ne $null) { try { $timer.Dispose()   } catch {} }
        Start-Sleep -Milliseconds 150
        if (Test-Path $tempLogoPath) {
            try { Remove-Item $tempLogoPath -Force -ErrorAction SilentlyContinue } catch {}
        }

    } catch {
        # WinForms unavailable or error — continue silently without splash
    }
}

# ── SHOW BANNER FIRST ─────────────────────────────────────────────────────────
Show-InstallerBanner

# ── CONSOLE HEADER ────────────────────────────────────────────────────────────
Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "             PPTX to PDF Merger  -  Installation Wizard          " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# ── DEVELOPER DETAILS ─────────────────────────────────────────────────────────
Write-Host "  [+] Developer Details:" -ForegroundColor Green
Write-Host "      Name           : Mr. D.M. Prabhath Kelum Champika" -ForegroundColor White
Write-Host "      Designation    : CEO and Founder" -ForegroundColor White
Write-Host "      Company        : Pixel Forge Studio" -ForegroundColor White
Write-Host "      Website        : https://pixelforgestudioprabhath.netlify.app" -ForegroundColor White
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── LICENSE AGREEMENT FROM WEB ────────────────────────────────────────────────
Write-Host "Fetching License Agreement..." -ForegroundColor Gray

# Replace this URL with the actual address where you host license.html
# e.g. https://pixelforgestudioprabhath.netlify.app/license.html
$LicenseUrl = "https://pixelforgestudioprabhath.netlify.app/license"

try {
    # Fetch the license page
    $WebLicense = Invoke-RestMethod -Uri $LicenseUrl -ErrorAction Stop

    # ── Clean HTML → readable plain text ──
    # 1. Strip <style> and <script> blocks entirely (they produce garbage text)
    $LicenseText = $WebLicense -replace '(?s)<style[^>]*>.*?</style>', ''
    $LicenseText = $LicenseText -replace '(?s)<script[^>]*>.*?</script>', ''
    $LicenseText = $LicenseText -replace '(?s)<nav[^>]*>.*?</nav>', ''
    $LicenseText = $LicenseText -replace '(?s)<footer[^>]*>.*?</footer>', ''

    # 2. Remove all remaining HTML tags
    $LicenseText = $LicenseText -replace '<[^>]+>', ' '

    # 3. Decode common HTML entities
    $LicenseText = $LicenseText -replace '&amp;',  '&'
    $LicenseText = $LicenseText -replace '&lt;',   '<'
    $LicenseText = $LicenseText -replace '&gt;',   '>'
    $LicenseText = $LicenseText -replace '&#160;', ' '
    $LicenseText = $LicenseText -replace '&nbsp;', ' '
    $LicenseText = $LicenseText -replace '&mdash;','--'
    $LicenseText = $LicenseText -replace '&bull;', '*'

    # 4. Collapse excessive whitespace into single newlines
    $LicenseText = $LicenseText -replace '\r\n|\r', "`n"
    $LicenseText = $LicenseText -replace '[ \t]{2,}', ' '
    $LicenseText = $LicenseText -replace '(\n[ \t]*){3,}', "`n`n"

    # 5. Remove blank-only lines and trim
    $LicenseText = ($LicenseText -split "`n" |
                    ForEach-Object { $_.Trim() } |
                    Where-Object   { $_ -ne '' }) -join "`n"
    $LicenseText = $LicenseText.Trim()

} catch {
    # ── Fallback license (shown when the web URL is unreachable) ──
    $LicenseText = @"
=================================================================
                     PIXEL FORGE STUDIO
              PPTX TO PDF MERGER  -  V 0.0.1
           END USER LICENSE AGREEMENT (EULA)
=================================================================

NOTE: Could not load the full license from the web.
      Please visit $LicenseUrl to read the complete terms.

1. LICENSE GRANT
   A non-exclusive, non-transferable license is granted to
   install and use this Software on a single device for personal
   or internal business purposes only.

2. RESTRICTIONS
   You may NOT: copy, distribute, decompile, reverse-engineer,
   rent, lease, or use this Software for any unlawful purpose.

3. INTELLECTUAL PROPERTY
   All rights reserved. The Software is the exclusive property
   of Pixel Forge Studio. No ownership rights are transferred.

4. DISCLAIMER OF WARRANTIES
   THE SOFTWARE IS PROVIDED 'AS IS' WITHOUT ANY WARRANTY.
   PIXEL FORGE STUDIO DISCLAIMS ALL IMPLIED WARRANTIES.

5. LIMITATION OF LIABILITY
   PIXEL FORGE STUDIO SHALL NOT BE LIABLE FOR ANY INDIRECT,
   INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING FROM USE.

6. TERMINATION
   This license terminates automatically upon any breach.
   You must destroy all copies upon termination.

7. CONTACT
   Developer : Mr. D.M. Prabhath Kelum Champika
   Company   : Pixel Forge Studio
   Email     : prabhathkelum55@gmail.com
   WhatsApp  : +94 71 405 6318
   Website   : https://pixelforgestudioprabhath.netlify.app

(c) 2025  Pixel Forge Studio  -  All rights reserved.
"@
}

Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host $LicenseText -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# ── LICENSE ACCEPTANCE ────────────────────────────────────────────────────────
$Choice = Read-Host "Do you accept the terms above? (Type 'Y' to Accept / 'N' to Cancel)"

if ($Choice -ne "Y" -and $Choice -ne "y") {
    Write-Host "`n[-] Installation cancelled. License acceptance is required." -ForegroundColor Red
    Exit
}

Write-Host "`n[+] License accepted. Fetching components from server..." -ForegroundColor Green

# ── PATHS CONFIGURATION ───────────────────────────────────────────────────────
# Replace the zip URL with each new release tag as needed
$ZipUrl     = "https://github.com/Prabhath528/pptx-to-pdf-merger/releases/download/v0.0.2/pptx-to-pdf-merger.zip"
$TempZip    = "$env:TEMP\app_temp.zip"
$InstallDir = "$env:ProgramFiles\PPTX to PDF Merger"

# ── DOWNLOAD AND EXTRACT ──────────────────────────────────────────────────────
Write-Host "Downloading application files..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -ErrorAction Stop
} catch {
    Write-Host "ERROR: Failed to download the zip file. Check your internet connection or the release URL." -ForegroundColor Red
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
$WshShell              = New-Object -ComObject WScript.Shell
$Shortcut              = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\PPTX to PDF Merger.lnk")
$Shortcut.TargetPath   = "$InstallDir\main.exe"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Save()

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "  [+] Installation completed successfully!                       " -ForegroundColor Green
Write-Host "  [+] Installed to : $InstallDir" -ForegroundColor Green
Write-Host "  [+] Desktop shortcut created. You can now run the app.         " -ForegroundColor Green
Write-Host "  [+] Developed by Pixel Forge Studio  -  pixelforgestudioprabhath.netlify.app" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""
