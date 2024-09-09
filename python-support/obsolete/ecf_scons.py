#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

#	Description: invoke scons for Eiffel project ommitting first argument

import sys, os, imp, subprocess
from os import path

cpu = sys.argv [1]

if cpu == 'x86':
	os.environ ['ISE_PLATFORM'] = 'windows'
	os.environ ['ISE_EIFFEL'] = 'C:\\Program Files (x86)\\Eiffel Software\\Eiffel71'
else:
	os.environ ['ISE_PLATFORM'] = 'win64'
	os.environ ['ISE_EIFFEL'] = 'C:\\Program Files\\Eiffel Software\\Eiffel71'

os.environ ['ISE_LIBRARY'] = os.environ ['ISE_EIFFEL']
os.environ ['ISE_C_COMPILER'] = 'msc'

estudio_bin = path.expandvars ("$ISE_EIFFEL\\studio\\spec\\$ISE_PLATFORM\\bin")
mingw_bin = path.expandvars ("$ISE_EIFFEL\\gcc\\$ISE_PLATFORM\\mingw\bin")
msys_bin = path.expandvars ("$ISE_EIFFEL\\gcc\\$ISE_PLATFORM\\msys\\1.0\\bin")
os.environ ['PATH'] = "%s;%s;%s;%s" % (os.environ ['PATH'], estudio_bin, mingw_bin, msys_bin)

# sys.argv [2:] ommits cpu argument

scons_command = [sys.executable, path.join (path.dirname (sys.executable), 'Scripts', 'scons.py')] + sys.argv [2:]

code = subprocess.call (scons_command)
sys.exit (code)
