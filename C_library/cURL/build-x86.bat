@echo off

call "%MSDKBIN%\setenv.cmd" /x86 /Release /xp
set ISE_EIFFEL=D:\Program Files (x86)\Eiffel_16.05
set ISE_PLATFORM=windows
set EIFFEL_LOOP=D:\Eiffel\library\Eiffel-Loop
set PYTHONPATH=%PYTHONPATH%;%EIFFEL_LOOP%\tool\python-support
scons

pause

