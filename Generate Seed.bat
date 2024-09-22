@echo off
setlocal

set /p USER_SEED="Enter a seed (press Enter to generate a random seed): "

if not "%USER_SEED%"=="" (
    set SEED=%USER_SEED%
) else (
    for /f "delims=" %%i in ('powershell -command "Get-Random -Minimum 100000000 -Maximum 999999999"') do set SEED=%%i
)

echo|set /p="%SEED%" > seed.txt
echo New seed: %SEED%

pause