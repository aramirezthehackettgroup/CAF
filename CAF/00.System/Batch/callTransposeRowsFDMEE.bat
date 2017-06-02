@ECHO OFF

REM ---------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: APR 2017
REM LoadDataPBCS.bat
REM ---------------------------------------------------------

SETLOCAL ENABLEDELAYEDEXPANSION

SET readConfig=%cd%\00.System\Batch\readConfig.bat
SET inifile=%cd%\Config.ini

CALL %readConfig% %inifile% Global
CALL %readConfig% %inifile% %1


powershell %batch_dir%\transposeRowsFDMEE.ps1 -path %targetdir% -importFile %outputfile% -exportFile %finalfile% 


EXIT
