@ECHO OFF

REM ------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: Oct 2016
REM ResetService.bat 
REM ------------------------------------------------------

ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% Start of process - Refresh Application
ECHO -----------------------------------------------------
ECHO.


CALL %cd%\00.System\EPM_Automate\ResetServicePBCS.bat ResetService


ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO -----------------------------------------------------
ECHO.

EXIT