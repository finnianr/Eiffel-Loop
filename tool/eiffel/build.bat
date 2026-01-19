@echo off
Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

python -m eiffel_loop.scripts.ec_build_finalized
pause
