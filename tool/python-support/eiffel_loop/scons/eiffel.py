#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "3 June 2010"
#	revision: "0.1"

import sys, os, subprocess

from os import path
from eiffel_loop import osprocess
from eiffel_loop.eiffel import project
from eiffel_loop.distutils import dir_util
from distutils import file_util
from SCons import Script

# Builder routines

def copy_precompile (target, source, env):
	# Copy precompile into precomp/$ISE_PLATFORM
	file_util.copy_file (str (source [0]), str (target [0]))

def compile_eiffel (target, source, env):
	build = env ['EIFFEL_BUILD']
	build.pre_compilation ()
	build.compile ()

def compile_C_code (target, source, env):
	install = env.get ('install') and env.get ('action') == 'finalize'

	build = env ['C_BUILD']
	package_exe_path = path.join ('package', 'bin', build.exe_name)		

	if install and path.exists (package_exe_path):
		osprocess.sudo_call ([package_exe_path, '-uninstall'])

	build.pre_compilation ()
	build.compile ()
	build.post_compilation ()

	if install and path.exists (package_exe_path):
		osprocess.sudo_call ([package_exe_path, '-install'])

def write_ecf_from_pecf (target, source, env):
	# Converts Pyxis format PECF to XML
	pecf_path = str (source [0])
	sys.stdout.write ('Converting % to XML\n' % (pecf_path))
	if project.convert_pecf_to_xml (pecf_path) != 0:
		Script.Exit (1)

def check_C_libraries (env, build):
	print 'Checking for C libraries'
	# Check for availability of C libraries
	conf = Script.Configure (env)
	print 'IMPLICIT', build.implicit_C_libs
	for c_lib in build.implicit_C_libs:
		if not conf.CheckLib (c_lib):
			Script.Exit (1)
	env = conf.Finish()

	print 'EXPLICIT'
	for c_lib in build.explicit_C_libs:
		print 'Checking for C library %s... ' % c_lib,
		if path.exists (c_lib):
			print 'yes'
		else:
			print 'no'
			Script.Exit (1)

