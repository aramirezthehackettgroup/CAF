@ECHO OFF

REM ------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: Oct 2016
REM RunPlanTypeMap.bat
REM ------------------------------------------------------

ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% Start of process 
ECHO -----------------------------------------------------
ECHO.

CALL %cd%\00.System\EPM_Automate\RunPlanTypeMapPBCS.bat RunPlanTypeMap


ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO -----------------------------------------------------
ECHO.


EXIT