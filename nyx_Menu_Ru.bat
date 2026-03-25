@echo off
chcp 65001 >nul
title NYX: Anti-Forensics Cleaner
color 0A
mode con: cols=80 lines=20
:MENU
cls
echo ================================================================
echo        NYX CLEANER [v.1a] - МЕНЮ ЗАПУСКА (freetm@my.com)
echo ================================================================
echo.
echo  Пожалуйста, выберите опцию:
echo.
echo  [1] Тестовый режим (Dry Run - без изменений)
echo  [2] Обычная очистка (с подтверждением)
echo  [3] Принудительная очистка (без подтверждения)
echo  [4] Расширенная очистка (гибернация + файл подкачки)
echo  [5] Расширенная + Принудительная (без подтверждения)
echo  [6] Режим отладки (подробный вывод)
echo  [7] Выбор конкретных модулей
echo  [L] Сменить язык (English)
echo  [0] Выход
echo.
echo ================================================================
set /p choice="Введите ваш выбор (0-9, L): "

if "%choice%"=="1" goto DRYRUN
if "%choice%"=="2" goto NORMAL
if "%choice%"=="3" goto FORCE
if "%choice%"=="4" goto ADVANCED
if "%choice%"=="5" goto ADVANCEDFORCE
if "%choice%"=="6" goto DEBUG
if "%choice%"=="7" goto MODULES
if /i "%choice%"=="L" goto LANG_EN
if "%choice%"=="0" goto EXIT
echo Неверный выбор! Пожалуйста, попробуйте снова.
timeout /t 2 >nul
goto MENU

:DRYRUN
echo.
echo [i] Запуск в тестовом режиме (DRY RUN) - изменения не будут внесены
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -DryRun
@pause
goto MENU

:NORMAL
echo.
echo [i] Запуск обычной очистки (будет запрошено подтверждение)
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1"
@pause
goto MENU

:FORCE
echo.
echo [!] Запуск ПРИНУДИТЕЛЬНОЙ очистки - подтверждение НЕ требуется!
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Force
@pause
goto MENU

:ADVANCED
echo.
echo [!] Запуск РАСШИРЕННОЙ очистки (включая hiberfil.sys и pagefile)
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Advanced
@pause
goto MENU

:ADVANCEDFORCE
echo.
echo [!!] Запуск РАСШИРЕННОЙ + ПРИНУДИТЕЛЬНОЙ очистки - без подтверждения!
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Advanced -Force
@pause
goto MENU

:DEBUG
echo.
echo [i] Запуск с отладочным/подробным выводом (DEBUG)
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Debug
@pause
goto MENU

:MODULES
cls
echo ================================================================
echo                    ВЫБОР МОДУЛЕЙ ДЛЯ ОЧИСТКИ
echo ================================================================
echo.
echo  Доступные модули:
echo  [1] events     - Журналы событий Windows
echo  [2] history    - История PowerShell/CMD, prefetch, jump lists
echo  [3] registry   - Реестр MRU, история USB, BAM, ShimCache
echo  [4] filesystem - USN journal, корзина, thumbcache, SRUM
echo  [5] temp       - Временные файлы, DNS кэш, теневые копии
echo  [6] security   - Логи EDR/AV (CrowdStrike, SentinelOne и др.)
echo  [7] advanced   - Сертификаты, задачи, службы, VPN/WiFi
echo  [8] ВСЕ МОДУЛИ
echo  [0] Назад в меню
echo.
echo ================================================================
set /p mod_choice="Введите номера модулей (например, 1,3,5 или 8 для всех): "

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
echo [i] Запуск выбранных модулей: %mod_choice%
echo.
@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0nyx.ps1" -Modules %mod_choice%
@pause
goto MENU

:LANG_EN
echo.
echo [i] Переключение на English...
echo.
timeout /t 1 >nul
if exist "%~dp0nyx_Menu_En.bat" (
    start "" "%~dp0nyx_Menu_En.bat"
) else (
    echo [!] Файл nyx_Menu_En.bat не найден!
    timeout /t 2 >nul
)
exit

:EXIT
echo.
echo Спасибо за использование Nyx Cleaner!
echo.
timeout /t 2 >nul
exit