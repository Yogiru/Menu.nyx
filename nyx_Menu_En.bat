@echo off
chcp 65001 >nul
title NYX: Anti-Forensics Cleaner
color 0A
mode con: cols=80 lines=20
:MENU
cls
echo ================================================================
echo        NYX CLEANER [v.1a] - LAUNCH MENU (freetm@my.com)
echo ================================================================
echo.
echo  Please select an option:
echo.
echo  [1] Dry Run (Test mode - no changes)
echo  [2] Normal Clean (With confirmation)
echo  [3] Force Clean (No confirmation)
echo  [4] Advanced Clean (Include hiberfil/pagefile)
echo  [5] Advanced + Force (No confirmation)
echo  [6] Clean with Debug/Verbose output
echo  [7] Select Specific Modules
echo  [L] Change Language (Russian)
echo  [0] Exit
echo.
echo ================================================================
set /p choice="Enter your choice (0-9, L): "

if "%choice%"=="1" goto DRYRUN
if "%choice%"=="2" goto NORMAL
if "%choice%"=="3" goto FORCE
if "%choice%"=="4" goto ADVANCED
if "%choice%"=="5" goto ADVANCEDFORCE
if "%choice%"=="6" goto DEBUG
if "%choice%"=="7" goto MODULES
if /i "%choice%"=="L" goto LANG_RU
if "%choice%"=="0" goto EXIT
echo Invalid choice! Please try again.
timeout /t 2 >nul
goto MENU

:DRYRUN
echo.
echo [i] Running in DRY RUN mode - no changes will be made
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -DryRun
@pause
goto MENU

:NORMAL
echo.
echo [i] Running normal clean (will ask for confirmation)
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1"
@pause
goto MENU

:FORCE
echo.
echo [!] Running FORCE clean - NO confirmation required!
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Force
@pause
goto MENU

:ADVANCED
echo.
echo [!] Running ADVANCED clean (includes hiberfil.sys and pagefile)
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Advanced
@pause
goto MENU

:ADVANCEDFORCE
echo.
echo [!!] Running ADVANCED + FORCE - NO confirmation required!
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Advanced -Force
@pause
goto MENU

:DEBUG
echo.
echo [i] Running with DEBUG/Verbose output
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Debug
@pause
goto MENU

:MODULES
cls
echo ================================================================
echo                    SELECT MODULES TO CLEAN
echo ================================================================
echo.
echo  Available modules:
echo  [1] events     - Windows Event Logs
echo  [2] history    - PowerShell/CMD history, prefetch, jump lists
echo  [3] registry   - Registry MRUs, USB history, BAM, ShimCache
echo  [4] filesystem - USN journal, recycle bin, thumbcache, SRUM
echo  [5] temp       - Temporary files, DNS cache, shadow copies
echo  [6] security   - EDR/AV logs (CrowdStrike, SentinelOne, etc.)
echo  [7] advanced   - Certificates, tasks, services, VPN/WiFi
echo  [8] ALL MODULES
echo  [0] Back to Menu
echo.
echo ================================================================
set /p mod_choice="Enter module numbers (e.g., 1,3,5 or 8 for all): "

if "%mod_choice%"=="0" goto MENU
if "%mod_choice%"=="8" set mod_choice=events,history,registry,filesystem,temp,security,advanced
if "%mod_choice%"=="1" set mod_choice=events
if "%mod_choice%"=="2" set mod_choice=history
if "%mod_choice%"=="3" set mod_choice=registry
if "%mod_choice%"=="4" set mod_choice=filesystem
if "%mod_choice%"=="5" set mod_choice=temp
if "%mod_choice%"=="6" set mod_choice=security
if "%mod_choice%"=="7" set mod_choice=advanced

echo.
echo [i] Running selected modules: %mod_choice%
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Modules %mod_choice%
@pause
goto MENU

:LANG_RU
echo.
echo [i] Switching to Russian...
echo.
timeout /t 1 >nul
if exist "%~dp0nyx_Menu_Ru.bat" (
    start "" "%~dp0nyx_Menu_Ru.bat"
) else (
    echo [!] File nyx_Menu_Ru.bat not found!
    timeout /t 2 >nul
)
exit

:EXIT
echo.
echo Thank you for using Nyx Cleaner!
echo.
timeout /t 2 >nul
exit