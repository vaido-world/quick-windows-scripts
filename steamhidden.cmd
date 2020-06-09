@echo off


cd "C:\Program Files (x86)\Steam"

set "username=boqsc"
set /p password="Enter Password: "
cls
set "appID=228200"
set "launchParameters=-nomovies"

taskkill /F /IM  "steam.exe"
start Steam -login "%username%" "%password%" -applaunch "%appID%" "%launchParameters%"


REM TIMEOUT 10

:WAIT_FOR_COH_PROCESS 
tasklist | find "RelicCOH.exe"
IF %ERRORLEVEL% EQU 1 (
  GOTO :WAIT_FOR_COH_PROCESS 
) ELSE (
GOTO :CONTINUE
)


:CONTINUE
tasklist | find "RelicCOH.exe"
IF %ERRORLEVEL% EQU 0 (
  GOTO :CONTINUE
) ELSE (
taskkill /F /IM  "steam.exe"
start Steam -silent -login "uozas" "dsfsdfsdf"
timeout 5
taskkill /F /IM  "steam.exe"
)
