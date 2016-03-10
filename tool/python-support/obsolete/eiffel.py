#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "18 May 2009"
#	revision: "0.1"

# OBSOLETE MODULE

import os, string, sys

from subprocess import call
from glob import glob
from os import path

def print_status (prompt,  call_ret_code):
	if call_ret_code == 0:
		print prompt, 'OK'
	else:
		print prompt, 'ERROR'

def eifgen_code_path (code_dir_name, eifgen_name):
	for makefile_path in glob (path.join ('EIFGENs', eifgen_name, code_dir_name, 'Makefile')):
		return path.dirname (makefile_path)

#Build an Eiffel project

def __build_project (compilation_mode, code_dir_name, eifgen_name, location, ecf_name):
	print location, ecf_name
	cur_dir = path.abspath (os.curdir)
	compilation_switch = '-' + compilation_mode

	os.chdir (location)

	if not eifgen_code_path (code_dir_name, eifgen_name):
		ret_code = call (['ec', '-batch', compilation_switch, '-c_compile', '-config', ecf_name])
		print_status ('Compilation', ret_code)
		if not ret_code == 0:
			sys.exit ()

def freeze_project (location, ecf_name):
	__build_project("freeze", 'W_code', '*', location, ecf_name)

def finalize_project (location, ecf_name):
	__build_project ('finalize', 'F_code', '*', location, ecf_name )

def precompile_project (location, ecf_name):
	eifgen_name = string.lower (path.splitext(ecf_name) [0])
	__build_project ('precompile', 'W_code', eifgen_name, location, ecf_name )
	os.chdir (path.join (location, 'EIFGENs', eifgen_name, 'W_code'))

el_environment = dict ()

def put_env (name, value):
	global el_environment
	os.putenv (name, value)
	el_environment [name] = value

def set_eiffel_loop_environment (el_home, c_library_path):
	put_env ('EIFFEL_LOOP', el_home)
	put_env ('EL_PRECOMP', path.join (el_home, 'precomp') )

	jdk_home = '/usr/lib/jvm/default-java'
	for jvm_lib_path in glob ( path.join (jdk_home, 'jre/lib/*/server/libjvm.so')):
		print jvm_lib_path
		jdk_platform = string.split (jvm_lib_path, path.sep)[-3]
		print 'jdk_platform', jdk_platform
	
	jre_server_path = path.dirname (jvm_lib_path)
	put_env ('LD_LIBRARY_PATH', '$LD_LIBRARY_PATH:' + jre_server_path)

	put_env ('JDK_HOME', jdk_home)
	put_env ('JDK_PLATFORM', jdk_platform)
	put_env ('EXPAT', path.join (c_library_path, 'Expat'))
	put_env ('VTDXML_LIB', path.join (c_library_path, 'VTD-XML/lib'))
	put_env ('VTDXML_INCLUDE', path.join (c_library_path, 'VTD-XML/source/include'))    
	

def write_environment_to_sh_script ():
	global el_environment
	sh_file = open ('set_environment.sh', 'w')
	sh_file.write ('# Before launching EiffelStudio, call this script from a bash shell with the command:\n')
	sh_file.write ('#\n')
	sh_file.write ('# 	. ./set_environment.sh\n\n')
	env_names = el_environment.keys ()
	env_names.sort ()
	for name in env_names:
		sh_file.write ('export %s=%s\n' % (name, el_environment [name]))

	sh_file .close ()

