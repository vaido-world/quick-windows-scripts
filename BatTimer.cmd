@ECHO OFF & SETLOCAL EnableDelayedExpansion 





::Self overwrting settings

::IDEAS:
	::ECHO Hibernate: default
	::ECHO Sleep: optional


::ECHO @Set "Testing=yes" >> "BatTimerHibernate.cmd"
::type "BatTimer.cmd" >> "BatTimerHibernate.cmd"
::pause





::BETA
::After coming back from Sleep or Hibernation
IF EXIST WakeUpResetPowerSetting.xml (
::https://superuser.com/questions/321151/how-to-execute-a-script-on-sleep-hibernate-resume-and-shutdown
::schtasks /Delete /TN WakeUpResetPowerSetting
schtasks /Create /XML WakeUpResetPowerSetting.xml /TN WakeUpResetPowerSetting
)



:: Disable lid close for the current power plan.
CALL :getCurrentPowerPlan
(
	powercfg -SETACVALUEINDEX %currentPowerPlan% SUB_BUTTONS LIDACTION 000
	powercfg -SETDCVALUEINDEX %currentPowerPlan% SUB_BUTTONS LIDACTION 000
)
CALL :getCurrentPowerPlan
SET "emergencySavedCurrentPowerPlan=%currentPowerPlan%"

CALL :getCurrentPowerPlan
IF [%currentPowerPlan%]==[%LOW%] ( POWERcfg /SETACTIVE !HIGH!
	CALL :getCurrentPowerPlan
	IF [!currentPowerPlan!]==[!HIGH!] POWERcfg /SETACTIVE !LOW!
)

CALL :getCurrentPowerPlan
IF [%currentPowerPlan%]==[%MEDIUM%] ( POWERcfg /SETACTIVE !LOW!
	CALL :getCurrentPowerPlan
	IF [!currentPowerPlan!]==[!LOW!] POWERcfg /SETACTIVE !MEDIUM!
)

CALL :getCurrentPowerPlan
IF [%currentPowerPlan%]==[%HIGH%] ( POWERcfg /SETACTIVE !LOW!
	CALL :getCurrentPowerPlan
	IF [!currentPowerPlan!]==[!LOW!] POWERcfg /SETACTIVE !HIGH!
)
::-------------Running-suspension-of-the-computer-----------------::
ECHO Saved powerPlan before program's launch: %emergencySavedCurrentPowerPlan%


::Hibernate must be enabled before usage of this script 
::How to enable hibernate in Windows 10 - google it


::Make computer Sleep after TIMEOUT
TIMEOUT /t 920
CALL :reEnableLidClose
pause
::powercfg -hibernate off
rundll32.exe PowrProf.dll,SetSuspendState 0,1,0

::Hibernate the computer
::powercfg -hibernate on
::rundll32.exe PowrProf.dll,SetSuspendState Hibernate

powercfg /availablesleepstates


EXIT
:getCurrentPowerPlan
::Change performance plan.cmd
SET "HIGH=8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
SET "MEDIUM=381b4222-f694-41f0-9685-ff5bb260df2e"
SET "LOW=a1841308-3541-4fab-bc81-f71556f20b4a"
FOR /f "tokens=4" %%a IN ('powercfg getActiveScheme') DO set "currentPowerPlan=%%a"
GOTO :EOF


EXIT
:reEnableLidClose
:: Enable lid close for the current power plan.
CALL :getCurrentPowerPlan
(
	powercfg -SETACVALUEINDEX %currentPowerPlan% SUB_BUTTONS LIDACTION 001
	powercfg -SETDCVALUEINDEX %currentPowerPlan% SUB_BUTTONS LIDACTION 001
	:: Inform Windows about the change
	powercfg /SETACTIVE %currentPowerPlan%
)
GOTO :EOF