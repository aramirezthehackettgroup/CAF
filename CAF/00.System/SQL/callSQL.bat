@ECHO OFF

REM ------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: NOV 2016
REM callSQL.bat 
REM ------------------------------------------------------

ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% Start of process
ECHO -----------------------------------------------------
ECHO.

SETLOCAL ENABLEDELAYEDEXPANSION

SET readConfig=%cd%\00.System\Batch\readConfig.bat
SET inifile=%cd%\Config.ini

CALL %readConfig% %inifile% Global
CALL %readConfig% %inifile% %1

SET message="%date% %time% - Running SQL"
ECHO %message:"=%
sqlplus %user%/%password%@DATABASENAME @.\00.System\SQL\%sqlfile%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message%
EXIT )
ECHO.

ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO -----------------------------------------------------
ECHO.

EXIT

:ErrorPara 
ECHO.
ECHO ---------------------------------------------------------
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL%
ECHO 
ECHO ---------------------------------------------------------

EXIT