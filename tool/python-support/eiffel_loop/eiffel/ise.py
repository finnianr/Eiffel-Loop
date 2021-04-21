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

global key_c_compiler, key_library, key_precomp

key_c_compiler = 'ISE_C_COMPILER'
key_library = 'ISE_LIBRARY'
key_precomp = 'ISE_PRECOMP'
key_eiffel = 'ISE_EIFFEL'
key_platform = 'ISE_PLATFORM'

platform_win_x86 = 'windows'
platform_win_x64 = 'win64'

def precompile_template():
	if os.name == 'nt':
		result = r"~\Documents\Eiffel User Files\%s\precomp\spec\%s"
	else:
		result = "~/.es/eiffel_user_files/%s/precomp/spec/%s"

	return result

def precompile_path (a_platform):
	result = path.expanduser (path.expandvars (precompile_template () % (version (), a_platform)))
	return result

def version ():
	# EiffelStudio Version
	result = path.basename (eiffel).split ('_')[1]
	return result

def update ():
	global eiffel, platform, library, c_compiler, precomp

	# update globals from environ
	eiffel = environ [key_eiffel]
	platform = environ [key_platform]
	library = environ [key_library]

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
		precomp = precompile_path (platform)

update ()

