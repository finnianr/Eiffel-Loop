@echo off
Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\setenv.cmd" /x64 /Release /xp
set EIFFEL_LOOP=D:\Eiffel\Eiffel-Loop
scons

pause

