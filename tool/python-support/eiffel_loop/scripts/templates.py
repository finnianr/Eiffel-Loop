#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

from string import Template

# Unix

launch_estudio = '''#!/usr/bin/env bash
python -m eiffel_loop.scripts.launch_estudio $*
'''

# Windows
launch_estudio_bat = Template ('''@echo off
python -m eiffel_loop.scripts.launch_estudio %*
''')

set_msc_environment_txt = Template ('''@echo off
call "$setenv_cmd_path" %*
set > "%TEMP%\msc_environment.txt"
''')

escons_bat = Template ('''@echo off
set SCONS_ERRORLEVEL=
if "%OS%" == "Windows_NT" goto WinNT

@REM for 9x/Me you better not have more than 9 args
python -c "from os.path import join; import sys; sys.path = [ join(sys.prefix, 'Lib', 'site-packages', 'scons-2.1.0'), join(sys.prefix, 'Lib', 'site-packages', 'scons'), join(sys.prefix, 'scons-2.1.0'), join(sys.prefix, 'scons')] + sys.path; import SCons.Script; SCons.Script.main()" %1 %2 %3 %4 %5 %6 %7 %8 %9
@REM no way to set exit status of this script for 9x/Me
goto endscons

@REM Credit where credit is due:  we return the exit code despite our
@REM use of setlocal+endlocal using a technique from Bear's Journal:
@REM http://code-bear.com/bearlog/2007/06/01/getting-the-exit-code-from-a-batch-file-that-is-run-from-a-python-program/

:WinNT
setlocal
@REM ensure the script will be executed with the Python it was installed for

python "$python_home_dir\Scripts\scons.py" %*

endlocal & set SCONS_ERRORLEVEL=%ERRORLEVEL%

if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto returncode
if errorlevel 9009 echo you do not have python in your PATH
goto endscons

:returncode
exit /B %SCONS_ERRORLEVEL%

:endscons
call :returncode %SCONS_ERRORLEVEL%
''')

