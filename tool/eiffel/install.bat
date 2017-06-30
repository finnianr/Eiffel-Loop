@echo off

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

echo Installing in "C:\Program Files\Eiffel-Loop\bin"
copy /Y build\win64\package\bin\el_eiffel.exe "C:\Program Files\Eiffel-Loop\bin"
pause
