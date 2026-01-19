@echo off
@Rem Install to C:\Program Files\Eiffel-Loop\bin

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

copy build\win64\EIFGENs\classic\F_code\el_toolkit.exe "C:\Program Files\Eiffel-Loop\bin"
pause
