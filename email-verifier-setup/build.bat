@echo off
REM Email Verifier Setup Wizard Build Script for Windows
REM Automatically downloads and bundles Node.js

echo.
echo =========================================================
echo   Email Verifier Setup Wizard Builder
echo =========================================================
echo.

setlocal enabledelayedexpansion

REM Step 1: Install npm dependencies
echo [1/5] Installing npm dependencies...
call npm install > nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: npm install failed
    exit /b 1
)
echo Done.
echo.

REM Step 2: Download Node.js
echo [2/5] Downloading portable Node.js...
if not exist "node-portable" mkdir node-portable
if not exist "temp-node" mkdir temp-node

REM Download Node.js using PowerShell
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://nodejs.org/dist/v18.17.1/node-v18.17.1-win-x64.zip', 'temp-node/node.zip')"
if !errorlevel! neq 0 (
    echo ERROR: Failed to download Node.js
    exit /b 1
)
echo Done.
echo.

REM Step 3: Extract Node.js
echo [3/5] Extracting Node.js...
powershell -Command "Expand-Archive -Path 'temp-node/node.zip' -DestinationPath 'temp-node' -Force"
xcopy /E /I /Y "temp-node\node-v18.17.1-win-x64\*" "node-portable\" > nul
echo Done.
echo.

REM Step 4: Verify Node.js
echo [4/5] Verifying Node.js...
call node-portable\node.exe --version > nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: Node.js verification failed
    exit /b 1
)
echo Done.
echo.

REM Step 5: Build installer
echo [5/5] Building installer...
call npm run build-win
if !errorlevel! neq 0 (
    echo ERROR: Build failed
    exit /b 1
)

REM Cleanup
rmdir /s /q temp-node > nul 2>&1

echo.
echo =========================================================
echo   Build Complete!
echo =========================================================
echo.
echo Your installer is ready in the 'dist' folder:
echo   - EmailVerifier-Setup.exe
echo.
echo Users can download and run this installer.
echo No additional software needed!
echo.
pause
