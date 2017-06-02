@ECHO OFF

REM ------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: JUL 2016
REM LoadData.bat 
REM ------------------------------------------------------

ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% Start of process
ECHO -----------------------------------------------------
ECHO.

CALL %cd%\00.System\EPM_Automate\LoadDataPBCS.bat LoadData-FINRPTG-FINRPTG-HIST-POST


ECHO.
ECHO -----------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO -----------------------------------------------------
ECHO.

EXIT