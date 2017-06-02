@ECHO OFF

REM ------------------------------------------------------
REM Script Title: Main.bat 
REM Created By: The Hackett Group
REM Date: JUL 2016
REM ------------------------------------------------------

ECHO.
ECHO ------------------------------------------------------
ECHO %DATE% - %TIME% Start of process
ECHO ------------------------------------------------------
ECHO.

START /wait %cd%\00.System\EPM_Automate\ImportMetadataPBCS.bat ImportMetadata

START /wait %cd%\00.System\EPM_Automate\ImportDataPBCS.bat ImportData


ECHO ------------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO ------------------------------------------------------

EXIT