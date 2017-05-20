@Rem Install to C:\Program Files\Eiffel-Loop\bin

echo Use admin permissions
pause

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

scons action=finalize project=toolkit.ecf
copy /Y build\win64\package\bin\el_toolkit.exe "C:\Program Files\Eiffel-Loop\bin"
pause
