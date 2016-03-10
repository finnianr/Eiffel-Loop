@echo off
Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

for %%p in (*.pyx)  do el_toolkit -pyxis_to_xml -in "%%p"

pause
