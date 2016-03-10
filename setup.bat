@echo off
echo WARNING: this script requires administrator permissions.
pause

Rem Change to directory containing batch file
set batch_drive=%~d0
set batch_path=%~p0
%batch_drive%
cd %batch_path%

python setup.py install
python -m eiffel_loop.scripts.setup

pause

