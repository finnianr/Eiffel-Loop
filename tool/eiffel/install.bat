@echo off

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

Rem echo Installing in "C:\Program Files\Eiffel-Loop\bin"
Rem copy /Y build\win64\package\bin\el_eiffel.exe "C:\Program Files\Eiffel-Loop\bin"

set PYTHONPATH=D:\Eiffel\library\Eiffel-Loop\tool\python-support;%PYTHONPATH%

python test_install.py --install "%ProgramFiles%\Eiffel-Loop\bin"

pause
