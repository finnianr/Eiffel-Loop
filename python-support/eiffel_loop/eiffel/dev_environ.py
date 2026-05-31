#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "7 Nov 2021"
#	revision: "0.2"

# DESCRIPTION
# Creates a default build environment for EiffelStudio projects based on the assumption
# that there is a directory "<root>/Eiffel/library" in the current path containing
# Eiffel libraries to be added to environment

import platform, os
from string import Template

from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.os import env as os_env

from eiffel_loop.eiffel import ise_environ
from eiffel_loop.C_util.C_dev import MICROSOFT_COMPILER_OPTIONS
from eiffel_loop.package import LIBRARY_NAME

from eiffel_loop.eiffel.test import TESTS

def eiffel_environ ():
	result = environ_extra.copy ()
	for key in os.environ:
		if not key in result:
			if key.startswith ("ISE_") or key.startswith ("EIFFEL"):
				result [key] = os.environ [key]

	return result

def new_eiffel_library_dir ():
	# the environment path $EIFFEL/library calculated even when `EIFFEL' is not defined
	# raise FileNotFoundError if it does not exist
	
	result = ''
	if eiffel_upper in os.environ:
		result = path.join (os.environ [eiffel_upper], library_basename)

	for i in range (2):
		if not path.exists (result):
			match i:
				case 0:
				#	Check for */Eiffel/* in current directory
					if eiffel_title in path.curdir ().split (os.sep):
						result = path.join (path.curdir_up_to (eiffel_title), library_basename)
				case 1:
					message = 'ERROR: cannot find Eiffel library directory\n\t'
					if not eiffel_upper in os.environ:
						message = message + 'Environment variable $%s is not defined\n\t' % eiffel_upper
						
					if path.exists (path.dirname (result)):
						detail = '"%s" does not have a library directory' % path.dirname (result)
					else:
						detail = "Current directory does not contain a '%s' step" % eiffel_title

					raise FileNotFoundError (message + detail)

	return result

def new_eiffel_library_table ():
	# table of generated environment variables for all libraries found under directory $EIFFEL/library
	# For example:
	# The presence of $EIFFEL/library/Eiffel-Loop-2.3.1 will pair
	#		EIFFEL_LOOP : '$EIFFEL/library/Eiffel-Loop'

	result = dict ()
	for name in os.listdir (eiffel_library_dir):
		file_path = path.join (eiffel_library_dir, name)
		if path.isdir (file_path):
			name = LIBRARY_NAME (file_path)
			# derive environ variable from library name stripped of version info
			result [name.base.upper ().replace ('-', '_')] = file_path
			
	return result

def print_environ ():
	for key in ['INCLUDE', 'LIB', 'LIBPATH', 'PATH', 'PYTHONPATH']:
		if key in os.environ:
			print()
			print(key + ':')
			for p in os.environ [key].split (os.pathsep):
				if p:
					print('  ', p)
	print()
	for name in sorted (eiffel_environ ()):
		print (name + " =", os.environ [name])

# routines to call from project.py

def append_to_path (search_dir):
	# append to search $PATH environment
	path_extra.append (path.normpath (search_dir))

def set_environ (name, a_path):
	normpath = path.normpath (a_path)
	if '$' in normpath:
		environ_extra [name] = Template (normpath).safe_substitute (environ_extra)
	else:
		environ_extra [name] = normpath

def set_ise_version (new_version):
	os.environ [ise.Key_version] = new_version

def set_ms_compiler_version (a_version):
	os.environ [ise.Key_c_compiler] = 'msc_vc' + a_version.replace ('.', '')

def set_ise_platform (a_platform):
	os.environ [ise.Key_platform] = a_platform

# SCRIPT BEGIN

global environ_extra, path_extra, ise, eiffel_upper, library_basename
global eiffel_title, eiffel_dir, eiffel_library_dir

ise = ise_environ.shared

MSC_options = MICROSOFT_COMPILER_OPTIONS ()

path_extra = []

# list of resource names relative to install directory that should be preserved after call to
# eiffel_loop.scripts.ec_install_resources

preserve_resources = []

eiffel_upper = 'EIFFEL'; eiffel_title = 'Eiffel'
library_basename = 'library'
eiffel_library_dir = new_eiffel_library_dir ()
eiffel_dir = path.dirname (eiffel_library_dir)

environ_extra = new_eiffel_library_table ()

# keep assertions in finalized build
keep_assertions = False

build_info_path = 'source/build_info.e'

# Build intermediate F_code-<platform>.tar for 32-bit build without Eiffel compilation
build_f_code_tar = False
compile_eiffel = True

if os.name == 'posix':
	set_environ ('LANG', 'C')



