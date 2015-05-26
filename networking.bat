REM Simple script to lookup networking information by possible command we have in Windows environment.

@echo off

if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

REM Resolve your hostname by
hostname

REM get your MAC address
getmac

REM get info about computer
id

REM Get all networking data
ipconfig /all

REM potential usage later
@echo:

REM set /p IP="Enter your IP address: "
set IP="14.69.42.54"

ping %IP% 
@echo:

tracert %IP% 
@echo:

nslookup %IP%

pause