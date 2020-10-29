@echo off
Set /A COUNTER=0
Set /A TIME=0

:hours
SET /P HOURS=Input number of hours before restart here:
SET "var="&for /f "delims=0123456789" %%i in ("%HOURS%") do set var=%%i
if defined var (goto :hours) else (goto :status)

:status
tasklist|find /i "BeamMP-Server.exe" >NUL
if errorlevel 1 goto :start
if errorlevel 0 goto :timer

:start 
start "" BeamMP-Server.exe -e -m -v
Set /A COUNTER=0
goto :status

:check
if %COUNTER%==%HOURS% goto :restart
Set /A COUNTER=COUNTER+1
echo Hours up time %counter%
goto :updates

:updates
for %%i in (Server.cfg) do echo %%~ai|find "a">nul || goto :status
echo Server configuration updated, server restarting....
Set /A TIME=0
rem do workload
attrib -a Server.cfg
timeout /t 5 /nobreak
goto :restart

:timer
timeout /t 60 /nobreak
echo Checking for updates...
Set /A TIME=TIME+60
if %TIME%==3600 goto:check
goto :updates

:restart
taskkill -im "BeamMP-Server.exe"
echo Server shutdown
goto :start