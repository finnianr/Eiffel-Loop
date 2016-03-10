@echo off
Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

estudio -project_path build\win64 -config test.ecf
