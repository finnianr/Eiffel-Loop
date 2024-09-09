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

import platform, sys, os
from string import Template

from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.eiffel import ise_environ
from eiffel_loop.C_util.C_dev import MICROSOFT_COMPILER_OPTIONS

from eiffel_loop.eiffel.test import TESTS

def is_version_number (a_str):
	if a_str [-1].isalpha ():
		# Eg. 0.15.1b -> 0.15.1
		parts = a_str [0:-1].split ('.')
	else:	
		parts = a_str.split ('.')

	result = all (s.isdigit () for s in parts)
	return result

def library_environ_name (lib_name):
	result = lib_name
	hypen_pos = lib_name.rfind ('-')
	if hypen_pos > 0:
		if is_version_number (lib_name [hypen_pos + 1:]):
			result = lib_name [: hypen_pos]
	
	result = result.upper ().replace ('-', '_')

	return result

def eiffel_environ ():
	result = environ_extra.copy ()
	for key in os.environ:
		if not key in result:
			if key.startswith ("ISE_") or key.startswith ("EIFFEL"):
				result [key] = os.environ [key]

	return result

def eiffel_library_dir ():
	cur_dir = path.curdir (); result = ''; eiffel_dir = ''
	if var_eiffel in os.environ:
		result = path.join (os.environ [var_eiffel], library_basename)

	if not path.exists (result):
		if eiffel_basename in cur_dir.split (os.sep):
			eiffel_dir = path.curdir_up_to (eiffel_basename)
			result = path.join (eiffel_dir, library_basename)

	if not path.exists (result):
		print 'ERROR: cannot find "library" directory'
		if var_eiffel in os.environ:
			print '\tEnvironment variable $%s not defined' % var_eiffel
		if path.exists (eiffel_dir):
			print '\t"%s" does not have a library directory' % eiffel_dir
		else:
			print "\tCannot find step %s in current directory path" % eiffel_basename

		exit (0)

	return result

def set_environ_from_directory (a_dir):
	for name in os.listdir (a_dir):
		file_path = path.join (a_dir, name)
		if path.isdir (file_path):
			environ_extra [library_environ_name (name)] = file_path

def set_c_externals_environ (prefix, a_dir):
	print 'a_dir', a_dir
	# set C/C++ external library location env labels
	for c_name in ["C", "C++"]:
		c_dir = path.join (eiffel_dir, path.normpath (a_dir), c_name)
		if path.exists (c_dir):
			for name in os.listdir (c_dir):
				dir_path = path.join (c_dir, name)
				if path.isdir (dir_path):
					c_type = path.basename (path.dirname (dir_path)).replace ('+', 'P')
					label = '_'.join ([prefix, c_type, library_environ_name (name)])
					environ_extra [label] = dir_path
		else:
			print "not found", c_dir


def print_environ ():
	for key in ['INCLUDE', 'LIB', 'LIBPATH', 'PATH', 'PYTHONPATH']:
		if key in os.environ:
			print
			print key + ':'
			for p in os.environ [key].split (os.pathsep):
				if p:
					print '  ', p
	print
	for name in sorted (eiffel_environ ()):
		print name + " =", os.environ [name]

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

global environ_extra, path_extra, ise, var_eiffel, eiffel_basename, library_basename, eiffel_dir

ise = ise_environ.shared

MSC_options = MICROSOFT_COMPILER_OPTIONS ()

path_extra = []

# list of resource names relative to install directory that should be preserved after call to
# eiffel_loop.scripts.ec_install_resources

preserve_resources = []

environ_extra = { 
	# Java
	'JDK_HOME' 						: environ.jdk_home (),

	# Third party C/C++ libraries
	'PYTHON_HOME'   				: environ.python_home_dir (),
	'PYTHON_LIB_NAME'	  			: environ.python_dir_name ()
}

var_eiffel = 'EIFFEL'
eiffel_basename = 'Eiffel'
library_basename = 'library'
eiffel_dir = path.dirname (eiffel_library_dir ())

# keep assertions in finalized build
keep_assertions = False

build_info_path = 'source/build_info.e'

# Build intermediate F_code-<platform>.tar for 32-bit build without Eiffel compilation
build_f_code_tar = False
compile_eiffel = True

set_environ_from_directory (eiffel_library_dir ())

# set labels subdirectories of $EIFFEL/external/C and $EIFFEL/external/C++

set_c_externals_environ ('EXT', 'external')
set_c_externals_environ ('EL',  'library/Eiffel-Loop/contrib')
	
set_environ ('EL_CONTRIB',	'$EIFFEL_LOOP/contrib')
set_environ ('EL_C_LIB',	'$EIFFEL_LOOP/C_library')

if not sys.platform == 'win32':
	set_environ ('LANG', 'C')



