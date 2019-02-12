#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

# DESCRIPTION
# Creates a default build environment for EiffelStudio projects based on the assumption
# that there is a directory "<root>/Eiffel/library" in the current path containing
# Eiffel libraries to be added to environment

import platform, sys, os
from string import Template

from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.C_util import C_dev
from eiffel_loop.eiffel import project

from eiffel_loop.eiffel.test import TESTS

global environ

def expanded_path (a_path):
	result = Template (path.expandvars (path.normpath (a_path))).safe_substitute (environ)
	return result

def set_environ (name, a_path):
	environ [name] = expanded_path (a_path)

def is_version_number (a_str):
	parts = a_str.split ('.')
	return all (s.isdigit () for s in parts)

def library_environ_name (lib_name):
	parts = lib_name.split ('-')
	if len (parts) > 1:
		if is_version_number (parts [-1]):
			parts = parts [0:-1]
	return ('_').join (parts).upper ()

def set_environ_from_directory (a_dir):
	for name in os.listdir (a_dir):
		file_path = path.join (a_dir, name)
		if path.isdir (file_path):
			environ [library_environ_name (name)] = file_path

def set_build_environment (target_cpu):
	# set C build environment for `target_cpu'
	cpu_options = ['x86', 'x64']
	if not target_cpu in cpu_options:
		raise Exception ('Invalid argument: set_build_environment (target_cpu)', target_cpu)
		exit (1)

	print "Setting %s build environment" % target_cpu
	if sys.platform == 'win32':
		# Adjust setenv.cmd arguments `MSC_options'
		for opt in cpu_options:
			setenv_option = '/' + opt
			if setenv_option in MSC_options:
				MSC_options.remove (setenv_option)
				break

		MSC_options.insert (0, '/' + target_cpu)

		os.environ.update (C_dev.msvc_compiler_environ (MSC_options, os.environ ['ISE_C_COMPILER'] == 'msc_vc140'))
		if target_cpu == 'x86':
			os.environ.update (project.x86_environ (environ))
		else:
			os.environ.update (environ)

	else:
		os.environ.update (environ)

	for name in sorted (eiffel_environ ()):
		print name + " =", os.environ [name]

def eiffel_environ ():
	result = environ.copy ()
	for key in os.environ:
		if not key in result:
			if key.startswith ("ISE_") or key.startswith ("EIFFEL"):
				result [key] = os.environ [key]

	return result
	

# SCRIPT BEGIN

environ = { 
	# Java
	'JDK_HOME' 						: environ.jdk_home (),

	# Third party C/C++ libraries

	'PYTHON_HOME'   				: environ.python_home_dir (),
	'PYTHON_LIB_NAME'	  			: environ.python_dir_name ()
}

var_eiffel = 'EIFFEL'
var_ise_library = 'ISE_LIBRARY'
eiffel_basename = 'Eiffel'
library_basename = 'library'
cur_dir = path.curdir ()

if not var_ise_library in os.environ:
	os.environ [var_ise_library] = os.environ ['ISE_EIFFEL']

if var_eiffel in os.environ:
	library_dir = path.join (os.environ [var_eiffel], library_basename)
else:
	library_dir = None

if not library_dir or not path.exists (library_dir):
	if eiffel_basename in cur_dir.split (os.sep):
		eiffel_dir = path.curdir_up_to (eiffel_basename)
		library_dir = path.join (eiffel_dir, library_basename)
	else:
		eiffel_dir = None
		library_dir = None
	

if not library_dir or not path.exists (library_dir):
	print 'ERROR: cannot find "library" directory'
	print '\t"$EIFFEL/library" does not exist'
	if library_dir and eiffel_dir:
		print '\t and "%s" does not exist' % library_dir
	sys.exit (1)


if not path.exists (library_dir):
	print 'ERROR: "%s" does not have an Eiffel "library" directory' % eiffel_dir
	sys.exit (1)

set_environ_from_directory (library_dir)
	
set_environ ('EXPAT',				'$EIFFEL_LOOP/contrib/C/Expat')
set_environ ('VTD_XML_INCLUDE',	'$EIFFEL_LOOP/contrib/C/VTD-XML.2.7/include')
set_environ ('EIFFEL_LOOP_C',		'$EIFFEL_LOOP/C_library')

MSC_options = ['/x64', '/win7', '/Release']

if not sys.platform == 'win32':
	environ ['LANG'] = 'C'



