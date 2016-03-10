@echo off

call "%MSDKBIN%\setenv.cmd" /x64 /Release /xp
set ISE_EIFFEL=D:\Program Files\Eiffel_15.01
set ISE_PLATFORM=win64
set EIFFEL_LOOP=D:\Eiffel\Eiffel-Loop
set PYTHONPATH=%PYTHONPATH%;%EIFFEL_LOOP%\tool\python-support
scons

pause

