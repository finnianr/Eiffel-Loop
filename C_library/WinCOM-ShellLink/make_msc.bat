Rem Source file: make_msc.bat
Rem Copyright Finnian Reilly 2008
Rem finnian at eiffel-loop dot com

set INCLUDE=%MSVC%\include;%PLATFORM_SDK%\Include
cd source

nmake /f Makefile.msc
pause