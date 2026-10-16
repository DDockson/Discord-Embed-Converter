@echo off
setlocal
chcp 65001 >nul
title Discord Embed Converter

:MENU
cls
echo ==========================================
echo    Discord Embed Converter
echo ==========================================
echo.
echo   1. Install
echo   2. Uninstall
echo   3. Exit
echo.
choice /c 123 /n /m "Select an option (1-3): "

if errorlevel 3 exit /b
if errorlevel 2 goto UNINSTALL
if errorlevel 1 goto INSTALL


:INSTALL
cls
echo.
echo Installing Discord Embed Converter...
echo.

set "INSTALL_DIR=C:\Skripts"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Discord Embed Converter.lnk"
set "BAT_PATH=%~f0"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

if not exist "%INSTALL_DIR%" (
    echo ERROR: Cannot create C:\Skripts
    echo Try checking folder permissions.
    pause
    goto MENU
)

REM Extract both scripts and create the shortcut.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$src=[IO.File]::ReadAllText($env:BAT_PATH); $p=[regex]::Match($src,'(?ms)^#PS1_BEGIN\r?\n(.*?)^#PS1_END\r?$'); $v=[regex]::Match($src,'(?ms)^#VBS_BEGIN\r?\n(.*?)^#VBS_END\r?$'); if(!$p.Success -or !$v.Success){Write-Error 'Script sections not found'; exit 2}; [IO.File]::WriteAllText('C:\Skripts\converter.ps1',$p.Groups[1].Value,[Text.UTF8Encoding]::new($false)); [IO.File]::WriteAllText('C:\Skripts\converter.vbs',$v.Groups[1].Value,[Text.Encoding]::ASCII); $w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut($env:APPDATA+'\Microsoft\Windows\Start Menu\Programs\Startup\Discord Embed Converter.lnk'); $s.TargetPath='C:\Skripts\converter.vbs'; $s.WorkingDirectory='C:\Skripts'; $s.Description='Discord Embed Converter'; $s.Save(); if(!(Test-Path 'C:\Skripts\converter.ps1') -or !(Test-Path 'C:\Skripts\converter.vbs') -or !(Test-Path $s.FullName)){exit 3}"

if errorlevel 1 (
    echo.
    echo ERROR: Installation failed.
    echo Check the error message above.
    pause
    goto MENU
)

echo.
echo Installation completed successfully.
echo Install folder: C:\Skripts
echo Startup shortcut created.
echo.

choice /c YN /n /m "Start converter now? (Y/N): "
if errorlevel 2 goto MENU

start "" "C:\Skripts\converter.vbs"

echo.
set /p "=Converter started. Press Enter to return to menu: "
goto MENU


:UNINSTALL
cls
echo.
echo Removing Discord Embed Converter...
echo.

set "INSTALL_DIR=C:\Skripts"
set "SHORTCUT_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Discord Embed Converter.lnk"

REM Stop only the PowerShell process running converter.ps1.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$needle='C:\Skripts\'+'converter.ps1'; Get-CimInstance Win32_Process | Where-Object { ($_.Name -eq 'powershell.exe' -or $_.Name -eq 'pwsh.exe') -and $_.ProcessId -ne $PID -and $_.CommandLine -and $_.CommandLine.Contains($needle) } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }"

timeout /t 2 /nobreak >nul

REM Remove the startup shortcut.
if exist "%SHORTCUT_PATH%" del /f /q "%SHORTCUT_PATH%"

REM Remove only this program's files.
if exist "%INSTALL_DIR%\converter.ps1" del /f /q "%INSTALL_DIR%\converter.ps1"
if exist "%INSTALL_DIR%\converter.vbs" del /f /q "%INSTALL_DIR%\converter.vbs"

REM Remove the directory only if it is empty.
if exist "%INSTALL_DIR%" (
    dir /a /b "%INSTALL_DIR%" 2>nul | findstr "." >nul
    if errorlevel 1 rmdir "%INSTALL_DIR%" 2>nul
)

REM Verify removal.
if exist "%SHORTCUT_PATH%" goto UNINSTALL_FAILED
if exist "%INSTALL_DIR%\converter.ps1" goto UNINSTALL_FAILED
if exist "%INSTALL_DIR%\converter.vbs" goto UNINSTALL_FAILED

echo.
echo Uninstallation completed successfully.
echo.
pause
goto MENU


:UNINSTALL_FAILED
echo.
echo WARNING: Some files could not be removed.
echo Close programs using these files and try again.
echo Other files in C:\Skripts were preserved.
echo.
pause
goto MENU


REM Do not move the script sections above the menu logic.
REM These sections are extracted during installation.

#PS1_BEGIN
$lastClipboard = ""

Write-Host "Discord Embed Converter running..." -ForegroundColor Green

while ($true) {
    try {
        $clip = Get-Clipboard -Raw -ErrorAction Stop

        if ($clip -and $clip -ne $lastClipboard) {
            $lastClipboard = $clip

            $pattern = 'https?://(?:www\.)?(?:x\.com|twitter\.com)/[^\s<>"''\]]+|https?://(?:www\.)?instagram\.com/(?:reel|p|tv)/[^\s<>"''\]]+'

            $newClip = [regex]::Replace($clip, $pattern, {
                param($m)

                $url = $m.Value.TrimEnd('.', ',', ')', '!', '?')
                $suffix = $m.Value.Substring($url.Length)

                if ($url -match '^https?://(?:www\.)?(?:x\.com|twitter\.com)/') {
                    $path = $url -replace '^https?://(?:www\.)?(?:x\.com|twitter\.com)/', ''
                    $path = ($path -split '\?')[0].TrimEnd('/')
                    $result = "https://fixupx.com/$path"
                }
                else {
                    $path = $url -replace '^https?://(?:www\.)?instagram\.com/', ''
                    $path = ($path -split '\?')[0].TrimEnd('/')
                    $result = "https://www.oginstagram.com/$path"
                }

                return $result + $suffix
            })

            if ($newClip -ne $clip) {
                Set-Clipboard -Value $newClip
                $lastClipboard = $newClip
                Write-Host "Link converted: $newClip" -ForegroundColor Cyan
            }
        }
    }
    catch {
        # Retry on the next cycle.
    }

    Start-Sleep -Milliseconds 500
}
#PS1_END

#VBS_BEGIN
Set WshShell = CreateObject("WScript.Shell")

scriptPath = "C:\Skripts\converter.ps1"

WshShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & scriptPath & """", 0, False

Set WshShell = Nothing
#VBS_END