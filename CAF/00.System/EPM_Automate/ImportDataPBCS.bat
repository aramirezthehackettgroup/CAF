@ECHO OFF

REM ---------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: JUL 2016
REM ImportDataPBCS.bat 
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
ECHO Archive folder   : %backupfiledir% >> %log_file%
ECHO.>> %log_file%

ECHO PBCS url         : %url%
ECHO Log file         : %log_file%
ECHO Archive folder   : %backupfiledir%
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


SET message="%date% %time% - Delete File"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% deletefile %filename% >> %log_file%
IF %ERRORLEVEL% EQU 0 (
      GOTO:PROCESS
   ) ELSE IF %ERRORLEVEL% EQU 8 (
      ECHO Info: No file to delete in INBOX >> %log_file%
       ECHO Info: No file to delete in INBOX
      GOTO:PROCESS
   ) ELSE (
       CALL :ErrorPara %message% %log_file% 
       EXIT
   )
   
:PROCESS
   
ECHO.
ECHO.>> %log_file%
SET message="%date% %time% - Upload File"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% uploadfile %sourcefiledir%\%filename% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
EXIT )
ECHO.
ECHO.>> %log_file%


SET message="%date% %time% - Import Data"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% importdata %jobname% %filename% >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
REM EXIT
)
ECHO.
ECHO.>> %log_file%

SET message="%date% %time% - Archive Data file"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
MOVE %sourcefiledir%\%filename% %backupfiledir% >> %log_file%
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

REN %backupfiledir%\%filename% %file_base%_%timestamp%.%extn% >> %log_file%

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

PAUSE
EXIT

:ErrorPara 
ECHO.
ECHO ---------------------------------------------------------
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL%
ECHO Logging Out. Go to %url% for details.
ECHO ---------------------------------------------------------
ECHO.
ECHO. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL% >> %~2
ECHO Logging Out. Go to %url% for details. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO. >> %~2

powershell %batch_dir%\sendEmail.ps1 -email %email% -attachment %log_file% -jobname %jobname% -url %url%

EXIT
