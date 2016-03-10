@echo off
if not exist soundbow-display.exe goto no_flash_projector

set /p debug_on="Start Soundbow with debug output (y/n): "
if "%debug_on%"=="y" set cmd_option=-logging -console

start "Soundbow Debug Console" EIFGENs\classic\F_code\sound-analyzer -soundbow %cmd_option%
goto end

:no_flash_projector
echo ERROR: soundbow-display.exe not found!
echo .
echo To build the Flash display executable open 'soundbow.fla' with 
echo Flash Professional 8.0 and menu select File/Publish
echo (Keyboard shortcut: Shift-F12)
echo .
pause

:end
