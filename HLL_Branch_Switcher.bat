@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

rem ==========================================================
rem  HLL Branch Switcher (Hell Let Loose) - APPID 686810
rem  Config file: HLL_BranchSwitcher.cfg (next to this .bat)
rem ==========================================================

set "APPID=686810"
set "CFG_FILE=%~dp0HLL_BranchSwitcher.cfg"

call :EnsureConfig
call :LoadConfig

:MENU
cls
echo ==========================================================
echo              HLL Branch Switcher (APPID %APPID%)
echo ==========================================================
echo(
echo Current configuration:
echo   Steam.exe    : %STEAM_EXE%
echo   SteamApps    : %STEAMAPPS%
echo(
echo  1) Switch to NORMAL
echo  2) Switch to EXPERIMENTAL
echo(
echo  4) Setup Steam Path (steam.exe)
echo  5) Setup SteamApps Path (steamapps)
echo(
echo  7) Save CURRENT installation as NORMAL
echo  8) Save CURRENT installation as EXPERIMENTAL
echo(
echo  9) Exit
echo(
set /p "SEL=Select option: "

if "%SEL%"=="1" goto SWITCH_NORMAL
if "%SEL%"=="2" goto SWITCH_EXPERIMENTAL
if "%SEL%"=="4" goto SETUP_STEAM
if "%SEL%"=="5" goto SETUP_STEAMAPPS
if "%SEL%"=="7" goto SAVE_AS_NORMAL
if "%SEL%"=="8" goto SAVE_AS_EXPERIMENTAL
if "%SEL%"=="9" goto END

echo(
echo Invalid selection.
pause
goto MENU


rem =========================
rem Option 1: Switch to NORMAL
rem =========================
:SWITCH_NORMAL
call :LoadConfig
call :RequirePaths
if errorlevel 1 goto MENU

call :KillProcesses

set "M_ACTIVE=%STEAMAPPS%\appmanifest_%APPID%.acf"
set "M_N=%STEAMAPPS%\appmanifest_%APPID%_normal.acf"
set "M_E=%STEAMAPPS%\appmanifest_%APPID%_experimental.acf"
set "COMMON=%STEAMAPPS%\common"

if not exist "%M_N%" goto SWN_NO_NORMAL
if not exist "%M_ACTIVE%" goto SWN_NO_ACTIVE

if exist "%M_E%" del /F /Q "%M_E%" >nul 2>&1

pushd "%STEAMAPPS%"
if errorlevel 1 goto ERR_OPEN_STEAMAPPS

ren "appmanifest_%APPID%.acf" "appmanifest_%APPID%_experimental.acf" >nul 2>&1
if errorlevel 1 goto SWN_REN_FAIL1

ren "appmanifest_%APPID%_normal.acf" "appmanifest_%APPID%.acf" >nul 2>&1
if errorlevel 1 goto SWN_REN_FAIL2

popd

pushd "%COMMON%"
if errorlevel 1 goto ERR_OPEN_COMMON

if not exist "Hell Let Loose_normal" goto SWN_NO_HLL_NORMAL
if exist "Hell Let Loose_experimental" goto SWN_HLL_EXP_EXISTS
if not exist "Hell Let Loose" goto SWN_NO_HLL_ACTIVE

ren "Hell Let Loose" "Hell Let Loose_experimental" >nul 2>&1
if errorlevel 1 goto SWN_HLL_REN_FAIL1

ren "Hell Let Loose_normal" "Hell Let Loose" >nul 2>&1
if errorlevel 1 goto SWN_HLL_REN_FAIL2

popd

echo(
echo Switch to NORMAL completed.
call :StartSteam
pause
goto MENU

:SWN_NO_NORMAL
echo(
echo [ABORT] appmanifest_%APPID%_normal.acf not found:
echo         "%M_N%"
echo         No switch performed.
echo(
pause
goto MENU

:SWN_NO_ACTIVE
echo(
echo [ABORT] Live appmanifest_%APPID%.acf not found:
echo         "%M_ACTIVE%"
echo(
echo Install/download a branch in Steam first so Steam recreates:
echo   - appmanifest_%APPID%.acf
echo   - common\Hell Let Loose
echo Then run the switch option again.
echo(
pause
goto MENU

:SWN_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%.acf to ..._experimental.
echo(
pause
goto MENU

:SWN_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%_normal.acf to appmanifest_%APPID%.acf.
echo(
pause
goto MENU

:SWN_NO_HLL_NORMAL
popd
echo(
echo [ABORT] Folder "Hell Let Loose_normal" not found.
echo         No switch performed.
echo(
pause
goto MENU

:SWN_HLL_EXP_EXISTS
popd
echo(
echo [ABORT] Folder "Hell Let Loose_experimental" already exists.
echo         Please rename/remove it so the switch can be done safely.
echo(
pause
goto MENU

:SWN_NO_HLL_ACTIVE
popd
echo(
echo [ABORT] Active folder "Hell Let Loose" not found.
echo(
echo Install/download a branch in Steam first so Steam recreates:
echo   - common\Hell Let Loose
echo Then run the switch option again.
echo(
pause
goto MENU

:SWN_HLL_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose" to "Hell Let Loose_experimental".
echo(
pause
goto MENU

:SWN_HLL_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose_normal" to "Hell Let Loose".
echo(
pause
goto MENU


rem ==============================
rem Option 2: Switch to EXPERIMENTAL
rem ==============================
:SWITCH_EXPERIMENTAL
call :LoadConfig
call :RequirePaths
if errorlevel 1 goto MENU

call :KillProcesses

set "M_ACTIVE=%STEAMAPPS%\appmanifest_%APPID%.acf"
set "M_N=%STEAMAPPS%\appmanifest_%APPID%_normal.acf"
set "M_E=%STEAMAPPS%\appmanifest_%APPID%_experimental.acf"
set "COMMON=%STEAMAPPS%\common"

if not exist "%M_E%" goto SWE_NO_EXP
if not exist "%M_ACTIVE%" goto SWE_NO_ACTIVE

if exist "%M_N%" del /F /Q "%M_N%" >nul 2>&1

pushd "%STEAMAPPS%"
if errorlevel 1 goto ERR_OPEN_STEAMAPPS

ren "appmanifest_%APPID%.acf" "appmanifest_%APPID%_normal.acf" >nul 2>&1
if errorlevel 1 goto SWE_REN_FAIL1

ren "appmanifest_%APPID%_experimental.acf" "appmanifest_%APPID%.acf" >nul 2>&1
if errorlevel 1 goto SWE_REN_FAIL2

popd

pushd "%COMMON%"
if errorlevel 1 goto ERR_OPEN_COMMON

if not exist "Hell Let Loose_experimental" goto SWE_NO_HLL_EXP
if exist "Hell Let Loose_normal" goto SWE_HLL_NORMAL_EXISTS
if not exist "Hell Let Loose" goto SWE_NO_HLL_ACTIVE

ren "Hell Let Loose" "Hell Let Loose_normal" >nul 2>&1
if errorlevel 1 goto SWE_HLL_REN_FAIL1

ren "Hell Let Loose_experimental" "Hell Let Loose" >nul 2>&1
if errorlevel 1 goto SWE_HLL_REN_FAIL2

popd

echo(
echo Switch to EXPERIMENTAL completed.
call :StartSteam
pause
goto MENU

:SWE_NO_EXP
echo(
echo [ABORT] appmanifest_%APPID%_experimental.acf not found:
echo         "%M_E%"
echo         No switch performed.
echo(
pause
goto MENU

:SWE_NO_ACTIVE
echo(
echo [ABORT] Live appmanifest_%APPID%.acf not found:
echo         "%M_ACTIVE%"
echo(
echo Install/download a branch in Steam first so Steam recreates:
echo   - appmanifest_%APPID%.acf
echo   - common\Hell Let Loose
echo Then run the switch option again.
echo(
pause
goto MENU

:SWE_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%.acf to ..._normal.
echo(
pause
goto MENU

:SWE_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%_experimental.acf to appmanifest_%APPID%.acf.
echo(
pause
goto MENU

:SWE_NO_HLL_EXP
popd
echo(
echo [ABORT] Folder "Hell Let Loose_experimental" not found.
echo         No switch performed.
echo(
pause
goto MENU

:SWE_HLL_NORMAL_EXISTS
popd
echo(
echo [ABORT] Folder "Hell Let Loose_normal" already exists.
echo         Please rename/remove it so the switch can be done safely.
echo(
pause
goto MENU

:SWE_NO_HLL_ACTIVE
popd
echo(
echo [ABORT] Active folder "Hell Let Loose" not found.
echo(
echo Install/download a branch in Steam first so Steam recreates:
echo   - common\Hell Let Loose
echo Then run the switch option again.
echo(
pause
goto MENU

:SWE_HLL_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose" to "Hell Let Loose_normal".
echo(
pause
goto MENU

:SWE_HLL_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose_experimental" to "Hell Let Loose".
echo(
pause
goto MENU


rem =========================
rem Option 4: Setup steam.exe path
rem =========================
:SETUP_STEAM
call :LoadConfig
echo(
echo Current: %STEAM_EXE%
echo(
set /p "INP=Enter full path to steam.exe (blank to cancel): "
if "%INP%"=="" goto MENU

set "STEAM_EXE=%INP%"
call :NormalizeVar STEAM_EXE

if not exist "%STEAM_EXE%" (
  echo(
  echo [ERROR] File not found: "%STEAM_EXE%"
  pause
  goto MENU
)

call :SaveConfig
echo(
echo Saved.
pause
goto MENU


rem =========================
rem Option 5: Setup steamapps path
rem =========================
:SETUP_STEAMAPPS
call :LoadConfig
echo(
echo Current: %STEAMAPPS%
echo(
set /p "INP=Enter full path to steamapps folder (blank to cancel): "
if "%INP%"=="" goto MENU

set "STEAMAPPS=%INP%"
call :NormalizeVar STEAMAPPS

if not exist "%STEAMAPPS%" (
  echo(
  echo [ERROR] Folder not found: "%STEAMAPPS%"
  pause
  goto MENU
)

if not exist "%STEAMAPPS%\common" (
  echo(
  echo [ERROR] "%STEAMAPPS%\common" not found. This does not look like a steamapps folder.
  pause
  goto MENU
)

call :SaveConfig
echo(
echo Saved.
pause
goto MENU


rem =======================================
rem Option 7: Save CURRENT installation as NORMAL
rem =======================================
:SAVE_AS_NORMAL
call :LoadConfig
call :RequirePaths
if errorlevel 1 goto MENU

set "M_ACTIVE=%STEAMAPPS%\appmanifest_%APPID%.acf"
set "M_N=%STEAMAPPS%\appmanifest_%APPID%_normal.acf"
set "M_E=%STEAMAPPS%\appmanifest_%APPID%_experimental.acf"
set "COMMON=%STEAMAPPS%\common"

rem ---- NEW: If EXPERIMENTAL backup exists and LIVE exists, do NOT touch anything ----
if exist "%M_E%" goto SAN_CHECK_SKIP
goto SAN_DO_WORK

:SAN_CHECK_SKIP
if exist "%M_ACTIVE%" goto SAN_CHECK_SKIP2
goto SAN_DO_WORK

:SAN_CHECK_SKIP2
if exist "%COMMON%\Hell Let Loose" goto SAN_SKIP_COMPLETE
goto SAN_DO_WORK

:SAN_SKIP_COMPLETE
echo(
echo Setup already complete.
echo You already have EXPERIMENTAL saved, and a live installation exists.
echo You can start switching now:
echo  - Use option 2 to switch to EXPERIMENTAL.
echo  - The first switch will automatically create the NORMAL backup.
echo(
pause
goto MENU

:SAN_DO_WORK
call :KillProcesses

if exist "%M_N%" goto SAN_ALREADY
if not exist "%M_ACTIVE%" goto SAN_NO_ACTIVE

pushd "%STEAMAPPS%"
if errorlevel 1 goto ERR_OPEN_STEAMAPPS

ren "appmanifest_%APPID%.acf" "appmanifest_%APPID%_normal.acf" >nul 2>&1
if errorlevel 1 goto SAN_REN_FAIL1
popd

pushd "%COMMON%"
if errorlevel 1 goto ERR_OPEN_COMMON

if not exist "Hell Let Loose" goto SAN_NO_HLL_ACTIVE
if exist "Hell Let Loose_normal" goto SAN_HLL_EXISTS

ren "Hell Let Loose" "Hell Let Loose_normal" >nul 2>&1
if errorlevel 1 goto SAN_REN_FAIL2

popd

echo(
echo CURRENT installation has been saved as NORMAL.
goto SAN_AFTER

:SAN_ALREADY
echo(
echo NORMAL is already saved (appmanifest_%APPID%_normal.acf exists).
goto SAN_AFTER

:SAN_NO_ACTIVE
echo(
echo [ABORT] Live appmanifest_%APPID%.acf not found:
echo         "%M_ACTIVE%"
echo(
echo Install/download a branch in Steam first so a live install exists.
echo(
pause
goto MENU

:SAN_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%.acf to ..._normal.
echo(
pause
goto MENU

:SAN_NO_HLL_ACTIVE
popd
echo(
echo [ABORT] Folder "Hell Let Loose" not found.
echo(
pause
goto MENU

:SAN_HLL_EXISTS
popd
echo(
echo [ABORT] Folder "Hell Let Loose_normal" already exists (would be overwritten).
echo(
pause
goto MENU

:SAN_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose" to "Hell Let Loose_normal".
echo(
pause
goto MENU

:SAN_AFTER
echo(
if exist "%M_E%" goto SAN_BOTH_SAVED

echo Next steps:
echo  1. Start Steam and install/download the EXPERIMENTAL branch fully.
echo  2. After it is installed, start switching immediately:
echo     - Use option 2 to switch to EXPERIMENTAL.
echo  3. You do NOT need to run option 8.
echo(
pause
goto MENU

:SAN_BOTH_SAVED
echo Both NORMAL and EXPERIMENTAL backups are present.
echo You can use option 1 or 2 to switch (make sure a live install exists).
echo(
pause
goto MENU


rem ===========================================
rem Option 8: Save CURRENT installation as EXPERIMENTAL
rem ===========================================
:SAVE_AS_EXPERIMENTAL
call :LoadConfig
call :RequirePaths
if errorlevel 1 goto MENU

set "M_ACTIVE=%STEAMAPPS%\appmanifest_%APPID%.acf"
set "M_N=%STEAMAPPS%\appmanifest_%APPID%_normal.acf"
set "M_E=%STEAMAPPS%\appmanifest_%APPID%_experimental.acf"
set "COMMON=%STEAMAPPS%\common"

rem ---- NEW: If NORMAL backup exists and LIVE exists, do NOT touch anything ----
if exist "%M_N%" goto SAE_CHECK_SKIP
goto SAE_DO_WORK

:SAE_CHECK_SKIP
if exist "%M_ACTIVE%" goto SAE_CHECK_SKIP2
goto SAE_DO_WORK

:SAE_CHECK_SKIP2
if exist "%COMMON%\Hell Let Loose" goto SAE_SKIP_COMPLETE
goto SAE_DO_WORK

:SAE_SKIP_COMPLETE
echo(
echo Setup already complete.
echo You already have NORMAL saved, and a live installation exists.
echo You can start switching now:
echo  - Use option 1 to switch to NORMAL.
echo  - The first switch will automatically create the EXPERIMENTAL backup.
echo(
pause
goto MENU

:SAE_DO_WORK
call :KillProcesses

if exist "%M_E%" goto SAE_ALREADY
if not exist "%M_ACTIVE%" goto SAE_NO_ACTIVE

pushd "%STEAMAPPS%"
if errorlevel 1 goto ERR_OPEN_STEAMAPPS

ren "appmanifest_%APPID%.acf" "appmanifest_%APPID%_experimental.acf" >nul 2>&1
if errorlevel 1 goto SAE_REN_FAIL1
popd

pushd "%COMMON%"
if errorlevel 1 goto ERR_OPEN_COMMON

if not exist "Hell Let Loose" goto SAE_NO_HLL_ACTIVE
if exist "Hell Let Loose_experimental" goto SAE_HLL_EXISTS

ren "Hell Let Loose" "Hell Let Loose_experimental" >nul 2>&1
if errorlevel 1 goto SAE_REN_FAIL2

popd

echo(
echo CURRENT installation has been saved as EXPERIMENTAL.
goto SAE_AFTER

:SAE_ALREADY
echo(
echo EXPERIMENTAL is already saved (appmanifest_%APPID%_experimental.acf exists).
goto SAE_AFTER

:SAE_NO_ACTIVE
echo(
echo [ABORT] Live appmanifest_%APPID%.acf not found:
echo         "%M_ACTIVE%"
echo(
echo Install/download a branch in Steam first so a live install exists.
echo(
pause
goto MENU

:SAE_REN_FAIL1
popd
echo(
echo [ABORT] Failed to rename appmanifest_%APPID%.acf to ..._experimental.
echo(
pause
goto MENU

:SAE_NO_HLL_ACTIVE
popd
echo(
echo [ABORT] Folder "Hell Let Loose" not found.
echo(
pause
goto MENU

:SAE_HLL_EXISTS
popd
echo(
echo [ABORT] Folder "Hell Let Loose_experimental" already exists (would be overwritten).
echo(
pause
goto MENU

:SAE_REN_FAIL2
popd
echo(
echo [ABORT] Failed to rename "Hell Let Loose" to "Hell Let Loose_experimental".
echo(
pause
goto MENU

:SAE_AFTER
echo(
if exist "%M_N%" goto SAE_BOTH_SAVED

echo Next steps:
echo  1. Start Steam and install/download the NORMAL branch fully.
echo  2. After it is installed, start switching immediately:
echo     - Use option 1 to switch to NORMAL.
echo  3. You do NOT need to run option 7.
echo(
pause
goto MENU

:SAE_BOTH_SAVED
echo Both NORMAL and EXPERIMENTAL backups are present.
echo You can use option 1 or 2 to switch (make sure a live install exists).
echo(
pause
goto MENU


rem =========================
rem Shared errors
rem =========================
:ERR_OPEN_STEAMAPPS
echo(
echo [ABORT] Could not open steamapps folder:
echo         "%STEAMAPPS%"
echo(
pause
goto MENU

:ERR_OPEN_COMMON
echo(
echo [ABORT] Could not open common folder:
echo         "%STEAMAPPS%\common"
echo(
pause
goto MENU


rem =========================
rem Helpers
rem =========================
:EnsureConfig
if not exist "%CFG_FILE%" (
  >"%CFG_FILE%" echo STEAM_EXE=
  >>"%CFG_FILE%" echo STEAMAPPS=
)
exit /b

:LoadConfig
set "STEAM_EXE="
set "STEAMAPPS="
for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%CFG_FILE%") do call :CfgSet "%%~A" "%%~B"
call :NormalizeVar STEAM_EXE
call :NormalizeVar STEAMAPPS
exit /b

:CfgSet
if /I "%~1"=="STEAM_EXE" set "STEAM_EXE=%~2"
if /I "%~1"=="STEAMAPPS" set "STEAMAPPS=%~2"
exit /b

:NormalizeVar
call set "tmp=%%%~1%%"
if not defined tmp (
  set "%~1="
  exit /b
)
set "tmp=%tmp:"=%"
for /f "tokens=* delims= " %%Z in ("%tmp%") do set "tmp=%%Z"
:TRIMR
if not "%tmp%"=="" if "%tmp:~-1%"==" " (
  set "tmp=%tmp:~0,-1%"
  goto TRIMR
)
if "%tmp:~1,2%"==":\" if "%tmp:~3%"=="" goto NORM_DONE
if not "%tmp%"=="" if "%tmp:~-1%"=="\" set "tmp=%tmp:~0,-1%"
:NORM_DONE
set "%~1=%tmp%"
exit /b

:SaveConfig
>"%CFG_FILE%" echo STEAM_EXE=%STEAM_EXE%
>>"%CFG_FILE%" echo STEAMAPPS=%STEAMAPPS%
exit /b

:RequirePaths
if not defined STEAM_EXE goto RP_NO_STEAM
if not defined STEAMAPPS goto RP_NO_APPS
if not exist "%STEAM_EXE%" goto RP_STEAM_MISSING
if not exist "%STEAMAPPS%\common" goto RP_APPS_INVALID
exit /b 0

:RP_NO_STEAM
echo(
echo [ERROR] Steam.exe path is missing. Please run option 4.
echo(
pause
exit /b 1

:RP_NO_APPS
echo(
echo [ERROR] SteamApps path is missing. Please run option 5.
echo(
pause
exit /b 1

:RP_STEAM_MISSING
echo(
echo [ERROR] steam.exe not found:
echo         "%STEAM_EXE%"
echo Please set it again via option 4.
echo(
pause
exit /b 1

:RP_APPS_INVALID
echo(
echo [ERROR] steamapps/common not found:
echo         "%STEAMAPPS%\common"
echo Please set it again via option 5.
echo(
pause
exit /b 1

:KillProcesses
echo(
echo Searching/killing: HLL-Win64-Shipping.exe ...
taskkill /F /IM HLL-Win64-Shipping.exe >nul 2>&1
echo Searching/killing: Steam.exe ...
taskkill /F /IM Steam.exe >nul 2>&1
timeout /t 2 /nobreak >nul
exit /b

:StartSteam
echo(
echo Starting Steam:
echo   "%STEAM_EXE%"
start "" "%STEAM_EXE%"
timeout /t 2 /nobreak >nul
exit /b

:END
endlocal
exit /b 0