@echo off

call set_environment.bat

set /p user_sure="Build finalized sound-analyzer demos? (y/n):"

if not "%user_sure%"=="y" goto end

if exist EIFGENs\classic del /S /Q EIFGENs\classic
if exist EIFGENs\classic rmdir /S /Q EIFGENs\classic

ec -batch -finalize -c_compile -config sound-analyzer.ecf

finish_freezing -silent -location EIFGENs\classic\F_code

:end


