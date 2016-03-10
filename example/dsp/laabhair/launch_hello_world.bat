@echo off
if not exist hello_world-display.exe goto no_flash_projector

set /p debug_on="Start hello_world with debug output (y/n): "
if "%debug_on%"=="y" set cmd_option=-logging -console

start "Hello World Debug Console" EIFGENs\classic\F_code\sound-analyzer -hello_world %cmd_option%
goto end

:no_flash_projector
echo ERROR: hello_world-display.exe not found!
echo .
echo To build the Flash display executable open 'hello_world.fla' with 
echo Flash Professional 8.0 and menu select File/Publish
echo (Keyboard shortcut: Shift-F12)
echo .
pause

:end
