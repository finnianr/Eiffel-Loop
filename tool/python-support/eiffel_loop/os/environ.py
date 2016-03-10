#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 July 2011"
#	revision: "0.1"

import os, platform, sys, imp, subprocess
from os import path

def python_home_dir ():
	return os.path.dirname (os.path.realpath (sys.executable))

def eiffel_loop_dir ():
	env_eiffel_loop = 'EIFFEL_LOOP'
	eiffel_loop = 'Eiffel-Loop'
	if env_eiffel_loop in os.environ:
		result = os.environ [env_eiffel_loop]
	else:
		result = path.abspath (os.curdir)
		if os.sep + eiffel_loop in result:
			while not path.basename (result).startswith (eiffel_loop):
				result = path.dirname (result)	
		else:
			result = None

	return result

def python_dir_name ():
	if os.name == 'posix':
		version_tuple = platform.python_version_tuple()
		result = 'python' + version_tuple[0] + '.' + version_tuple[1]
	else:
		result = path.basename (python_home_dir ())
		
	return result
	
def jdk_home ():
	if sys.platform == 'win32':
		import _winreg

		software_path = r'SOFTWARE\JavaSoft\Java Development Kit'
		try:
			key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, software_path, 0, _winreg.KEY_READ)
			jdk_version = _winreg.QueryValueEx (key, "CurrentVersion")[0]
		
			software_path = path.join (software_path, jdk_version)
			key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, software_path, 0, _winreg.KEY_READ)
			result = _winreg.QueryValueEx (key, "JavaHome")[0]
		
		except (WindowsError), err:
			result = 'Unknown'

	elif os.name == 'posix':
		result = None
		jvm_dir = '/usr/lib/jvm'
		for name in os.listdir (jvm_dir):
			result = path.join (jvm_dir, name)
			if path.isdir (result) and path.exists (path.join (result, 'jre/lib')):
				break
			else:
				result = None
		
	return result

def temp_dir ():
	if sys.platform == 'win32':
		result = os.environ ['TEMP']
	else:
		result = '/tmp'
	return result

def command_exists (command, shell = False):
	fnull_path = path.join (temp_dir (), 'python-null.txt')
	FNULL = open(fnull_path, 'w')
	try:
		result = subprocess.call (command, stdout=FNULL, stderr=FNULL, shell = shell) == 0
	except (Exception), e:
		result = False
	FNULL.close ()
	os.remove (fnull_path)
	return result
		

