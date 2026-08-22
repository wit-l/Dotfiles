@echo off
setlocal

rem Custom fzf preview script (based on chrisant996/clink-fzf).
rem Depends on: bat, chafa, eza (all on PATH).
rem Set CLINK_FZF_PREVIEW_SIXELS=1 for sixel image preview in supported terminals.

if "%~1" == "" goto :end

rem Strip fzf description suffix (at least 4 spaces before description).
set __ARG=%~1
set __DELIMITED=%__ARG:    =	%
for /f "tokens=1,2 delims=	" %%a in ("%__DELIMITED%") do set __ARG="%%a"

if %__ARG% == "" goto :end

rem Directory: list contents with eza.
if exist %__ARG%\ (
    eza -al %__ARG%
    goto :end
)

rem Image preview via chafa.
if x%__ARG:~1,1% == x- goto :try_file
set __CHAFA_OPTS=
if not x%CLINK_FZF_PREVIEW_SIXELS% == x set __CHAFA_OPTS=-f sixels
2>nul chafa %__CHAFA_OPTS% %__ARG%
if not errorlevel 1 goto :end

rem Text file preview via bat.
:try_file
bat --force-colorization --style=numbers,changes --line-range=:500 -- %__ARG%

:end
