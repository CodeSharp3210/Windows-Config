# === MENU DI SELEZIONE ===
Clear-Host
Write-Host "===== MENU CONFIGURAZIONI =====" -ForegroundColor Cyan
Write-Host "1. Configurazione 1 - Cascata / Rosso"
Write-Host "2. Configurazione 2 - macOS Dark / Viola"
Write-Host "3. Configurazione 3 - Windows 8 Preview / Verde Acqua"
Write-Host "================================"
$scelta = Read-Host "Scegli una configurazione (1-3)"

# === FUNZIONE: IMPOSTA SFONDO ===
function Imposta-Wallpaper($url, $nomeFile) {
    $destFolder = [Environment]::GetFolderPath("MyDocuments")
    $destPath = Join-Path $destFolder $nomeFile
    Write-Host "`nScaricamento sfondo in corso..."
    Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing
    Write-Host "Impostazione dello sfondo..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $destPath
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
}

# === FUNZIONE: IMPOSTA COLORE ===
function Imposta-Colore($nomeColore, $colorDWORD) {
    Write-Host "Impostazione del colore principale su $nomeColore..."
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name ColorPrevalence -Value 1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name ColorPrevalence -Value 1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AutoColorization -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name ColorizationColor -Value $colorDWORD -PropertyType DWORD -Force | Out-Null
}

# === FUNZIONE: ABILITA RIBBON WINDOWS 10 ===
function Abilita-Ribbon {
    $version = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
    $isWindows11 = [int]$version -ge 22000
    if ($isWindows11) {
        Write-Host "Windows 11 rilevato. Abilitazione vecchio Ribbon..."
        $regPath = "HKCU:\Software\Classes\CLSID\{d4fef94c-1326-4c45-9d0e-4ad4080b10e2}"
        New-Item -Path $regPath -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "System.IsPinnedToNameSpaceTree" -Value 0 -PropertyType DWORD -Force | Out-Null
        Write-Host "Ribbon abilitato."
    } else {
        Write-Host "Windows 11 non rilevato. Nessuna modifica al Ribbon necessaria."
    }
}

# === FUNZIONE: RIAVVIA ESPLORA FILE ===
function Riavvia-Explorer {
    Write-Host "Riavvio di Esplora file in corso..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process explorer
}

# === ESECUZIONE IN BASE ALLA SCELTA ===
switch ($scelta) {
    "1" {
        Imposta-Wallpaper "https://raw.githubusercontent.com/CodeSharp3210/Windows-Config/refs/heads/main/Cascata.jpg?token=GHSAT0AAAAAADJQZIQX2JFTENRXDH5HVKZA2FFVSHQ" "Cascata.jpg"
        Imposta-Colore "rosso" 4282550005
        Abilita-Ribbon
        Riavvia-Explorer
    }

    "2" {
        Imposta-Wallpaper "https://raw.githubusercontent.com/CodeSharp3210/Windows-Config/refs/heads/main/macOS%20Tahoe%20Dark.jpg?token=GHSAT0AAAAAADJQZIQWLMYHEYZDQ37GME3O2FFVTMA" "macOS_Tahoe_Dark.jpg"
        Imposta-Colore "viola" 4291943936
        Abilita-Ribbon
        Riavvia-Explorer
    }

    "3" {
        Imposta-Wallpaper "https://raw.githubusercontent.com/CodeSharp3210/Windows-Config/refs/heads/main/Windows%208%20Consumer%20Preview%20Wallpaper.jpg?token=GHSAT0AAAAAADJQZIQXSITIPPHNXMQFPGS62FFVUPQ" "Windows8.jpg"
        Imposta-Colore "verde acqua" 4286418962
        Abilita-Ribbon
        Riavvia-Explorer
    }

    default {
        Write-Host "❌ Scelta non valida. Riprova con un numero da 1 a 3." -ForegroundColor Red
    }
}

Write-Host "`n✅ Operazione completata." -ForegroundColor Green
