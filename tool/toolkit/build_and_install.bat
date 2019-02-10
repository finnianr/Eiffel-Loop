@echo off
Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

Rem scons action=finalize project=toolkit.ecf
python -m eiffel_loop.scripts.ec_build_finalized.py --install "%ProgramFiles%\Eiffel-Loop\bin"
pause
