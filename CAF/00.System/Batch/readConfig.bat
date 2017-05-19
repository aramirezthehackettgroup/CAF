@ECHO OFF
REM SETLOCAL
SET INIFile=%1
SET "FLAG="

for /f "usebackq tokens=1,*eol=|delims==" %%a in (%INIFile%) do (
 IF "%%b"=="" (
  REM No "=" so section
  IF /i "%%a"=="[%2]" (SET flag=Y) ELSE (SET "flag=")
 ) ELSE IF defined flag (
  REM data line - only if FLAG is defined
  REM set values defined
  SET "%%a=%%b"
  REM pick particular values
  if /i "%%a"=="Value1" set "Key1=%%b"
  rem if /i "%%a"=="Value2" set "Key2=%%b"
  rem if /i "%%a"=="Value3" set "Key3=%%b"
 )

)
REM SET key
REM SET val

GOTO :EOF