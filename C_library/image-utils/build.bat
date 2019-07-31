@echo off
Rem Build library from the command line 

Rem This script sets up the build environment before calling scons.

Rem add --x86 option to build 32-bit library
Rem Add -c option to clean up objects files after build

python -m eiffel_loop.scripts.build_c_library.py %*
