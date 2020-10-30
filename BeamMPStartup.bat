@echo off
Set /A COUNTER=0
Set /A UPTIME=0

:load1
color 74
echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :                    Flamers BeamMP Startup Script                   :
echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SET /P HOURS=Input number of hours before restart here:
SET "var="&for /f "delims=0123456789" %%i in ("%HOURS%") do set var=%%i
if defined var (goto :load1) else (goto :load2)

:load2
SET /P UPDATE=Input number of seconds between checks for config updates here:
SET "var="&for /f "delims=0123456789" %%i in ("%UPDATE%") do set var=%%i
if defined var (goto :load2) else (goto :run)

:run
cls
color 07
echo Loading...
ping 127.0.0.1 -n 2 > nul
echo Starting BeamMP Server
ping 127.0.0.1 -n 3 > nul
cls
goto :bau

:bau
color 74
echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo :                    Flamers BeamMP Startup Script                   :
echo ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto :status

:status
color 74
tasklist|find /i "BeamMP-Server.exe" >NUL
if errorlevel 1 goto :crash
if errorlevel 0 goto :timer

:crash
echo Server crashed at %time% %date%
echo Server crashed at %time% %date% >> FlamersLog.txt
goto :start

:start 
start "" BeamMP-Server.exe -e -m -v
Set /A COUNTER=0
echo Server started at %time% %date%
echo Server started at %time% %date% >> FlamersLog.txt
goto :status

:timer
ping 127.0.0.1 -n %UPDATE% > nul
echo Checking for updates...
Set /A UPTIME=UPTIME+%UPDATE%
if %UPTIME% GEQ 3600 goto:check
goto :updates

:check
Set /A UPTIME=0
Set /A COUNTER=COUNTER+1
ping 127.0.0.1 -n 1 > nul
if %COUNTER% GEQ %HOURS% goto :restart
echo Server has been up for %counter% number of hours
goto :updates

:updates
for %%i in (Server.cfg) do echo %%~ai|find "a">nul || goto :status
color 30
echo Server configuration updated, server restarting....
echo Server configuration updated at %time% %date% >> FlamersLog.txt
Set /A TIME=0
rem do workload
attrib -a Server.cfg
timeout /t 5 /nobreak
goto :restart

:restart
Set /A COUNTER=0
taskkill -im "BeamMP-Server.exe"
echo Shutting server down due to long uptime
echo Shutting server down due to long uptime at %time% %date% >> FlamersLog.txt
goto :start
