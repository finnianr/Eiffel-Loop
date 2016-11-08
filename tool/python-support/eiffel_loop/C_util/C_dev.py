#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.1"

import os, subprocess, sys

from distutils import dir_util
from distutils import file_util
from os import path
from subprocess import call

if sys.platform == "win32":
	import _winreg

def compiler_environ (MSC_options):
	if sys.platform == 'win32':
		result = msvc_compiler_environ (MSC_options)
	else:
		result = os.environ.copy ()

	return result

def microsoft_sdk_path ():
	# Better not to rely no MSDKBIN environ var
	key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\Microsoft\Microsoft SDKs\Windows', 0, _winreg.KEY_READ)
	result = _winreg.QueryValueEx (key, "CurrentInstallFolder")[0]
	return result

def msvc_compiler_environ (MSC_options):
	result = {}
	set_compiler_env_bat = 'set_msvc_compiler_environment.bat'
	set_env_cmd = path.join (microsoft_sdk_path (), r'Bin\setenv.cmd')

	f = open (set_compiler_env_bat, 'w')
	f.write ('@echo off\n')
	f.write ('call "%s" %s' %(set_env_cmd, (' ').join (MSC_options)))
	f.write ('\nset')
	f.close ()

	p = subprocess.Popen([set_compiler_env_bat], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	out, err = p.communicate()
	os.remove (set_compiler_env_bat)
	
	for line in out.split('\n'):
		pos_equal = line.find ('=') 
		if pos_equal > 0:
			name = line [0:pos_equal]
			value = line [pos_equal + 1:-1]
			# Fixes a problem on Windows for user maeda
			name = name.encode ('ascii'); value = value.encode ('ascii')
			result [name.upper ()] = value

	# Workaround for bug in setenv.cmd (SDK ver 7.1)
	# Add missing path "C:\Program Files\Microsoft SDKs\Windows\v7.1\Lib" to LIB

	lib_path = result ['LIB']
	std_lib_dir = result ['WINDOWSSDKDIR'] + 'Lib' # WINDOWSSDKDIR already has a '\' at the end
	if not std_lib_dir in lib_path.split (';'):
		result ['LIB'] = (';').join ([lib_path.rstrip (';'), std_lib_dir])

	return result
