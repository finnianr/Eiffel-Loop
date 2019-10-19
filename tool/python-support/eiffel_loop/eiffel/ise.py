#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

# DESCRIPTION
# Defines ISE Eiffel environment variables

import os
from os import environ
from os import path

from eiffel_loop import platform as system

def precompile_template():
	if os.name == 'nt':
		result = r"~\Documents\Eiffel User Files\%s\precomp\spec\%s"
	else:
		result = "~/.es/eiffel_user_files/%s/precomp/spec/%s"

	return result

def version ():
	result = path.basename (eiffel).split ('_')[1]
	return result

eiffel = environ ['ISE_EIFFEL']
platform = environ ['ISE_PLATFORM']
library = environ ['ISE_LIBRARY']

key_c_compiler = 'ISE_C_COMPILER'
key_library = 'ISE_LIBRARY'
key_precomp = 'ISE_PRECOMP'

if environ.has_key (key_c_compiler):
	c_compiler = environ [key_c_compiler]
elif system.is_unix ():
	c_compiler = 'gcc'
else:
	c_compiler = 'msc'
	
if environ.has_key (key_library):
	library = environ [key_library]
else:
	library = eiffel

if environ.has_key (key_precomp):
	precomp = environ [key_precomp]
else:
	precomp = path.expanduser (path.expandvars (precompile_template () % (version (), platform)))


