@echo off
setlocal
set "ROOT=%~1"
if "%ROOT%"=="" set "ROOT=."

where dirx.exe >nul 2>&1
if errorlevel 1 exit /b 1

pushd "%ROOT%" 2>nul
if errorlevel 1 exit /b 1
dirx.exe /b /s /X:d /a:-s-h --bare-relative --utf8 .
set "EC=%ERRORLEVEL%"
popd 2>nul
exit /b %EC%
