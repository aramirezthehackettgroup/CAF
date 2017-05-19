@ECHO OFF

REM ---------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: SEP 2016
REM ExportSnapshotPBCS.bat 
REM ---------------------------------------------------------

SETLOCAL ENABLEDELAYEDEXPANSION

SET readConfig=%cd%\00.System\Batch\readConfig.bat
SET inifile=%cd%\Config.ini

CALL %readConfig% %inifile% Global
CALL %readConfig% %inifile% %1

ECHO.
ECHO ---------------------------------------------------------
ECHO %DATE% - %TIME% Start of process
ECHO ---------------------------------------------------------
ECHO.

ECHO.> %log_file%
ECHO --------------------------------------------------------- >> %log_file%
ECHO %DATE% - %TIME% Start of process >> %log_file%
ECHO --------------------------------------------------------- >> %log_file%
ECHO.>> %log_file%

ECHO PBCS url         : %url% >> %log_file%
ECHO Log file         : %log_file% >> %log_file%
ECHO Outbox folder    : %download_dir% >> %log_file%
ECHO.>> %log_file%

ECHO PBCS url         : %url%
ECHO Log file         : %log_file%
ECHO Outbox folder   : %download_dir%
ECHO.

SET message="%date% %time% - Login"
ECHO ---------------------------------------------------------
ECHO %message:"=%
ECHO ---------------------------------------------------------
ECHO --------------------------------------------------------- >> %log_file%
ECHO %message:"=% >> %log_file%
ECHO --------------------------------------------------------- >> %log_file%
CALL %epmautomate_client% login %user% %password% %url% %domain% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO.
ECHO.>> %log_file%

SET message="%date% %time% - Export Snapshot %snapshotname%"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% exportsnapshot %snapshotname% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
)
ECHO.
ECHO.>> %log_file%

SET message="%date% %time% - Download File %snapshotname%"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% downloadfile %snapshotname% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO.
ECHO.>> %log_file%

SET message="%date% %time% - Move file %snapshotname%.zip to %targetdir%"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
MOVE %download_dir%\%snapshotname%.zip %targetdir% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO.
ECHO.>> %log_file%

SET message="%date% %time% - Rename and Archived Input file"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
FOR /f "tokens=1,2 delims=." %%a IN ("%filename%") do (
SET file_base=%%a
SET extn=%%b
)

SET timestamp=%date:~4,2%_%date:~7,2%_%date:~10,4%_%time:~0,2%%time:~3,2%%
SET timestamp=%timestamp: =0%

REN %targetdir%\%filename% %file_base%_%timestamp%.%extn%>> %log_file%

IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO Archive file name : %file_base%_%timestamp%.%extn%
ECHO Archive file name : %file_base%_%timestamp%.%extn% >> %log_file%
ECHO.
ECHO.>> %log_file%


SET message="%date% %time% - Logout"
ECHO ---------------------------------------------------------
ECHO %message:"=%
ECHO ---------------------------------------------------------
ECHO --------------------------------------------------------- >> %log_file%
ECHO %message:"=% >> %log_file%
ECHO --------------------------------------------------------- >> %log_file%
CALL %epmautomate_client% logout >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO.
ECHO.>> %log_file%

ECHO --------------------------------------------------------- >> %log_file%
ECHO %DATE% - %TIME% End of process>> %log_file%
ECHO --------------------------------------------------------- >> %log_file%

ECHO ---------------------------------------------------------
ECHO %DATE% - %TIME% End of process
ECHO ---------------------------------------------------------

EXIT

:ErrorPara 
ECHO.
ECHO ---------------------------------------------------------
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL%
ECHO Logging Out. Go to %url% for details.
ECHO 
ECHO ---------------------------------------------------------
ECHO.
ECHO. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL% >> %~2
ECHO Logging Out. Go to %url% for details. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO. >> %~2

powershell %batch_dir%\sendEmail.ps1 -email %email% -attachment %log_file% -snapshotname %snapshotname% -url %url%

EXIT

