@Rem Install to C:\Program Files\Eiffel-Loop\bin

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

set build_stamp=		# Build %date% %time%
echo %build_stamp% >> toolkit.pecf
el_toolkit2 -pyxis_to_xml -in toolkit.pecf

scons action=finalize project=toolkit.ecf
copy /Y package\win64\bin\el_toolkit2.exe "C:\Program Files\Eiffel-Loop\bin"
pause
