@ECHO OFF

REM ---------------------------------------------------------
REM The Hackett Group
REM Author: rjimenez
REM Date: Oct 2016
REM RunBusinessRulePBCS.bat 
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
ECHO.>> %log_file%

ECHO PBCS url         : %url%
ECHO Log file         : %log_file%
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


SET message="%date% %time% - Run Business Rule"
ECHO %message:"=%
ECHO %message:"=% >> %log_file%
CALL %epmautomate_client% runbusinessrule %rulename%  >> %log_file%
IF %ERRORLEVEL% NEQ 0 ( 
CALL :ErrorPara %message% %log_file% 
)
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
ECHO 
ECHO ---------------------------------------------------------
ECHO.
ECHO. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO Step Failed : %~1 with ErrorCode# %ERRORLEVEL% >> %~2
ECHO Logging Out. Go to %url% for details. >> %~2
ECHO --------------------------------------------------------- >> %~2
ECHO. >> %~2

powershell %batch_dir%\sendEmail.ps1 -email %email% -attachment %log_file% -rulename %rulename% -url %url%

EXIT
