@echo off
setlocal enabledelayedexpansion
color 00
cls

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "GRAY=%ESC%[90m"
set "YELLOW=%ESC%[93m"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "RESET=%ESC%[0m"

echo.
echo  %CYAN%+------------------------------------------+%RESET%
echo  %CYAN%^|                                          ^|%RESET%
echo  %CYAN%^|%RESET%             %WHITE%C L E A N & Q A%RESET%              %CYAN%^|%RESET%
echo  %CYAN%^|%RESET%                   %GRAY%v6.3%RESET%                   %CYAN%^|%RESET%
echo  %CYAN%^|                                          ^|%RESET%
echo  %CYAN%+------------------------------------------+%RESET%
echo.
echo  %GRAY%  Clinical Document Clean-up & QA Tool%RESET%
echo.
echo  %CYAN%-------------------------------------------%RESET%
echo.
echo  %GRAY%  Checking requirements...%RESET%
echo.

set "PYTHONHOME=%~dp0python"
set "PYTHONPATH=%~dp0python\Lib\site-packages"
set "PATH=%~dp0python;%~dp0python\Scripts;%PATH%"

set MISSING=0

"%~dp0python\python.exe" --version >nul 2>&1
if errorlevel 1 (
    echo  %RED%  [x] Python        - NOT FOUND%RESET%
    echo.
    echo  %RED%  ERROR: Embedded Python not found.%RESET%
    echo  %GRAY%  Re-download the complete Anonymizer package.%RESET%
    echo.
    pause
    exit /b 1
)
echo  %GREEN%  [+] Python        - OK%RESET%

"%~dp0python\python.exe" -c "import streamlit" >nul 2>&1
if errorlevel 1 (
    echo  %RED%  [x] Streamlit     - NOT FOUND%RESET%
    set MISSING=1
) else (
    echo  %GREEN%  [+] Streamlit     - OK%RESET%
)

"%~dp0python\python.exe" -c "import spacy" >nul 2>&1
if errorlevel 1 (
    echo  %RED%  [x] spaCy         - NOT FOUND%RESET%
    set MISSING=1
) else (
    echo  %GREEN%  [+] spaCy         - OK%RESET%
)

"%~dp0python\python.exe" -c "import presidio_analyzer" >nul 2>&1
if errorlevel 1 (
    echo  %RED%  [x] Presidio      - NOT FOUND%RESET%
    set MISSING=1
) else (
    echo  %GREEN%  [+] Presidio      - OK%RESET%
)

"%~dp0python\python.exe" -c "import lxml" >nul 2>&1
if errorlevel 1 (
    echo  %RED%  [x] lxml          - NOT FOUND%RESET%
    set MISSING=1
) else (
    echo  %GREEN%  [+] lxml          - OK%RESET%
)

if !MISSING!==1 (
    echo.
    echo  %RED%  Some dependencies are missing.%RESET%
    echo  %GRAY%  Re-run build_exe.py to reinstall.%RESET%
    echo.
    pause
    exit /b 1
)

echo.
echo  %CYAN%-------------------------------------------%RESET%
echo.
echo  %YELLOW%  Starting application...%RESET%
echo.
echo  %GRAY%  Browser  : %WHITE%Google Chrome%RESET%
echo  %GRAY%  Port     : %WHITE%5000%RESET%
echo.
echo  %GRAY%  To close, press %WHITE%Ctrl+C%GRAY% in this window.%RESET%
echo.
echo  %CYAN%-------------------------------------------%RESET%
echo.

start /b "" "http://localhost:5000"
"%~dp0python\python.exe" -m streamlit run "%~dp0app.py" --server.port 5000 --server.address localhost --server.headless true --browser.gatherUsageStats false

pause
